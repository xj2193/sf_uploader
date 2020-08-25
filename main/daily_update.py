import sys
sys.path.append('./main/')
import pandas as pd
import time
import argparse
import configparser
from connection import connect_sql_server, execute_sql_query, connect_sf
from sf_extract import SFDataExtraction as sfext
from db_extract_save import extract_data_db, save_data
from sf_update import UpdateRecord as upr
from data_converter import json_load
from sf_insert import InsertRecord as inr
from bulk import SFBulk as bk


def main():
    try:
        parser = argparse.ArgumentParser(description='Arguments for data updates')
        parser.add_argument('-env',
                            '--sf_environment',
                            help='Salesforce enviroment(production or sandbox)',
                            required=True)
        parser.add_argument('-db_set',
                            '--db_settings_path',
                            help='Path to database setting file',
                            required=True)
        parser.add_argument('-sf_set',
                            '--sf_settings_path',
                            help='Path to salesforce setting file')

        ARGS = parser.parse_args()
        db_config = configparser.ConfigParser()
        sf_config = configparser.ConfigParser()
        sf_environment = ARGS.sf_environment

        db_settings_path = ARGS.db_settings_path
        db_config.read(db_settings_path)
        db_settings = db_config.defaults()
        sf_settings_path = ARGS.sf_settings_path
        sf_config.read(sf_settings_path)
        sf_settings = sf_config.defaults()
        try:
            sf_api = connect_sf(sf_environment, sf_settings)
            print('Salesforce %s connected' % sf_environment)
        except Exception as e:
            print(str(e))
        try:
            query = "select 1 as test"
            conn = connect_sql_server(db_settings, db_settings['database_aou'])
            test_df = execute_sql_query(conn, query)
            if test_df.shape[0] >= 1:
                print('Sql Server connected')
            else:
                print('Sql Server not connected')
        except Exception as e:
            print(str(e))

        # ------------------------- Check if the HealthPro data is well loaded ------------------------------------------------#
        record_count_query = "select count(pmi_id_RC) from vw_reporting_base"
        # pmi_id_RC is the PMI_ID of participant
        # vw_reporting_base is the view table of the data source with Healthpro and REDCap data
        record_amount = execute_sql_query(conn, record_count_query).iloc[0][0]
        while record_amount <= 100:
            print('The HealthPro API is still working')
            time.sleep(600)
            record_amount = execute_sql_query(conn, record_count_query).shape[0]
        else:
            print('HealthPro and REDCap data is well loaded ')

        # ------------------------- Extract contacts and journeys from Salesforce and save in local DB ------------------------#

        # extract all salesforce contacts and save it locally
        sf_conn = connect_sql_server(db_settings, db_settings['database_sf'])
        print('Start extracting contact data')
        df_contact_sf = sfext(sf_api, 'extract_contact.sql', 'salesforce', 'contact', sf_settings).extract_data_sf()

        save_data(sf_conn, df_contact_sf, 'sf_contact', 'replace')

        print('Start extracting pardot contact data')
        # extract all pardot contacts and save it locally
        df_contact_pardot = sfext(sf_api,
                                  'extract_pardot_contact.sql',
                                  'pardot',
                                  'contact',
                                  sf_settings).extract_data_sf()
        save_data(sf_conn, df_contact_pardot, 'pardot_contact', 'replace')

        print('Start extracting journey data')
        # extract all journeys and save it locally
        df_journey_sf = sfext(sf_api,
                              'extract_participant_journey.sql',
                              'salesforce',
                              'opportunity',
                              sf_settings).extract_data_sf()
        save_data(sf_conn, df_journey_sf, 'sf_journey_export', 'replace')
        # ------------------------- Pull out new dataset from local DB to insert and update in SF -----------------------------#

        # pardot insert
        pardot_update_df = extract_data_db(sf_conn, 'pardot_contact_update.sql')
        pardot_log_file, pardot_update_count = upr(sf_api, json_load(pardot_update_df)).update_contact_records()
        save_data(sf_conn, pardot_log_file, 'contact_log', 'append')
        # sf insert
        contact_insert_df = extract_data_db(sf_conn, 'contact_insert.sql')
        contact_insert_df = contact_insert_df.drop(columns=['rowsha1', 'Id'])
        contact_log_file_insert, contact_insert_count = inr(sf_api, json_load(contact_insert_df)).insert_contact_sf()
        save_data(sf_conn, contact_log_file_insert, 'contact_log', 'append')

        # sf update
        contact_update_df = extract_data_db(sf_conn, 'contact_update.sql')
        contact_update_df = contact_update_df.drop(columns=['rowsha1'])
        contact_log_file_update, contact_update_count = upr(sf_api,
                                                            json_load(contact_update_df)).update_contact_records()
        save_data(sf_conn, contact_log_file_update, 'contact_log', 'append')

        # --------------------------- Create relationship table of contact, PMI and journey -----------------------------------#

        # Extract Contact_Id and PMI Id from Salesforce and save data into database
        print('Updating Relationship Table')
        query_contact = sf_api.bulk.Contact.query("SELECT Id, HP_PMI_ID__c FROM Contact "
                                                  "WHERE OwnerId = '{}' or OwnerId = '{}' "
                                                  "or OwnerId = '{}'".format(sf_settings['ownerid'],
                                                                             sf_settings['pardotuser1'],
                                                                             sf_settings['pardotuser2']))
        df_contact_pmi = pd.DataFrame(query_contact)[['Id', 'HP_PMI_ID__c']]
        df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']

        # Extract Journey Id and Contact Id from Salesforce and save data into database
        query_journey_id = sf_api.bulk.Opportunity.query("SELECT Id, Contact__c FROM Opportunity "
                                                         "WHERE OwnerId = '{}' or OwnerId = '{}'"
                                                         "or OwnerId = '{}'".format(sf_settings['ownerid'],
                                                                                    sf_settings['pardotuser1'],
                                                                                    sf_settings['pardotuser2']))
        df_journey_contact = pd.DataFrame(query_journey_id)[['Id', 'Contact__c']]
        df_journey_contact.columns = ['Journey_Id', 'Contact_Id']

        # Merge contact and journey file together to create a relationship table
        contact_journey_relation = pd.merge(df_contact_pmi, df_journey_contact, how='left', left_on='Contact_Id',
                                            right_on='Contact_Id')
        save_data(sf_conn, contact_journey_relation, 'contact_journey_relation', 'replace')

        # ------------------------------------------------- Update journey ----------------------------------------------------#
        print('Bulk Updating Journey')
        journey_update_df = extract_data_db(sf_conn, 'participant_journey_update.sql')
        journey_update_df = journey_update_df.drop(columns='Contact__c')
        bk(sf_api, journey_update_df, 'opportunity', 1000, 'update').bulk_upsert()

        print('Update withdrawal Participants')
        # update withdrawn participants
        withdrawal_df = extract_data_db(sf_conn, 'withdrawal_participant.sql')
        withdrawal_df_update = withdrawal_df[['Id', 'Contact__c', 'HP_Withdrawal_Date__c', 'HP_Withdrawal_Status__c']]
        withdrawal_log_file_update, withdrawal_update_count = upr(sf_api, json_load(
            withdrawal_df_update)).update_journey_records()
        save_data(sf_conn, withdrawal_log_file_update, 'journey_log', 'append')
        print('withdrawal status updated')

        # extract all salesforce contacts and save it locally again
        df_contact_sf = sfext(sf_api, 'extract_contact.sql', 'salesforce', 'contact', sf_settings).extract_data_sf()
        save_data(sf_conn, df_contact_sf, 'sf_contact', 'replace')
        print('sf contact data saved')

        # extract all pardot contacts and save it locally
        df_contact_pardot = sfext(sf_api, 'extract_pardot_contact.sql', 'pardot', 'contact',
                                  sf_settings).extract_data_sf()
        save_data(sf_conn, df_contact_pardot, 'pardot_contact', 'replace')
        print('pardot contact data saved')

        # extract all journeys and save it locally
        df_journey_sf = sfext(sf_api, 'extract_participant_journey.sql', 'salesforce', 'opportunity',
                              sf_settings).extract_data_sf()
        save_data(sf_conn, df_journey_sf, 'sf_journey_export', 'replace')
        print('journey data saved')

    except Exception as e:
        print(e)


if __name__ == '__main__':
    main()

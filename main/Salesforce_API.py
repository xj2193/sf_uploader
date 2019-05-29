from simple_salesforce import Salesforce, SalesforceMalformedRequest
from datetime import datetime
from sqlalchemy import create_engine
import json
import pandas as pd
import urllib
import datetime
import os
import sys
sys.path.append('C:\\Users\\xj2193\\PycharmProjects\\Salesforce API\\main')
import settings


def connect_sql_server(database):
    """

    Connect database using driver, server and database credentials
    :return: engine
    """
    # NOTE: It uses your windows authentication to connect to SQL Server so please be sure you have the access to DB
    conn_str = (
        r'Driver={};'
        r'Server={};'
        r'Database={};'
        r'Trusted_Connection=yes;'.format(settings.Driver, settings.Server, database)
    )
    quoted_conn_str = urllib.parse.quote_plus(conn_str)
    engine = create_engine('mssql+pyodbc:///?odbc_connect={}'.format(quoted_conn_str))
    return engine


def connect_sf():
    """

    Gain access to Salesforce by passing domain of your Salesforce instance and an access token.
    :return: Salesforce connection
    """
    # NOTE: Once you reset your password, the security token is reset automatically as well.
    # If it's a sandbox, add domain = 'test'
    sf = Salesforce(username=settings.sf_username, password=settings.sf_password,
                    security_token=settings.sf_security_token, domain='test', version=42.0)
    return sf


def openfile(root, filename):
    file = root + filename
    os.startfile(file)
    return 'open file: ' + filename


def extract_data(engine, sql_file_name):
    """

    Read sql file and extract data from DB
    :param engine: DB engine from connect_sql_server function
    :param sql_file_name: sql query to extract data
    :return: pandas dataframe
    """
    connect = engine.connect()
    query = open(sql_file_name, 'r')
    sql_file = query.read()
    query.close()
    df = pd.read_sql_query(sql_file, connect)
    return df


def insert_contact_sf(sf, record):
    """

    Loop through contact records and insert into Salesforce
    :param sf: Salesforce connection
    :param record: dataframe of contact records
    :return: how many new records are inserted
    """
    count = 0
    log = pd.DataFrame(columns=['PMI_ID', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
    for i in record:
        dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'Action': 'Create'}
        try:
            sf.Contact.create(i)
            dict_log['Success'] = 1
            dict_log['Error'] = ''
            count += 1
        except SalesforceMalformedRequest as e:
            dict_log['Success'] = 0
            dict_log['Error'] = "Error message:" + e.content[0]['message']
        dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log = log.append(dict_log, ignore_index=True)
    print(str(count) + ' of contacts are inserted')
    return log, count


def update_contact_sf(sf, record):
    count = 0
    log = pd.DataFrame(columns=['PMI_ID', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
    for i in record:
        dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'Action': 'Update'}
        contact_id = i['Id']
        try:
            del i['Id']
            sf.Contact.update(contact_id, i)
            count += 1
            dict_log['Success'] = 1
            dict_log['Error'] = ''
        except Exception as e:
            dict_log['Success'] = 0
            dict_log['Error'] = "Error message:" + str(e)
        dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log = log.append(dict_log, ignore_index=True)
    if len(record) == 0:
        print('0 contacts are updated')
    else:
        print(str(count) + '/' + str(len(record[0])) + 'contacts are updated')
    return log, count


def insert_journey_sf(sf, record):
    """

    Loop through journey records and insert into Salesforce
    :param sf: Salesforce connection
    :param record:  dataframe of journey records
    :return: how many new records are inserted
    """
    count = 0
    for i in record:
        try:
            sf.Opportunity.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' journeys inserted')


def update_journey_sf(sf, record):
    """

    Update journey records if there's any changes in DB
    :param sf: Salesforce connection
    :param record: dataframe of journey records
    :return: how many records are updated
    """
    count = 0
    log = pd.DataFrame(columns=['Journey_Id', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
    for i in record:
        dict_log = {'Journey_Id': i['Id'], 'Action': 'Update'}
        journey_id = i['Id']
        try:
            del i['Id']
            sf.Opportunity.update(journey_id, i)
            count += 1
            dict_log['Success'] = 1
            dict_log['Error'] = ''
        except Exception as e:
            dict_log['Success'] = 0
            dict_log['Error'] = "Error message:" + str(e)
        dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log = log.append(dict_log, ignore_index=True)
    print(str(count) + 'journeys are updated')
    return log, count


def save_data(df, engine, tablename, replace_option):
    """

    Save Pandas dataframe into SQL Server
    :param df: dataframe
    :param engine: SQL Server engine
    :param tablename: target table name in DB
    :return: how many records are inserted into DB
    """
    df.to_sql(tablename, engine, if_exists=replace_option, index=False)
    conn = engine.connect()
    num_record = pd.read_sql_query('SELECT COUNT(*) FROM %s' % tablename, conn)
    return str(num_record) + ' of records in database inserted'


def converter(o):
    """

    Convert datetime type into string to feed in json (function in json.dumps)
    :param o: object
    :return: JSON representation
    """
    if isinstance(o, pd.Timestamp):
        return o.strftime('%Y-%m-%d').__str__()
    elif isinstance(o, datetime.date):
        return o.__str__()


def delete_records(sf, record_type, record):
    """

    :param sf: Salesforce Connection
    :param record_type: Contact or Journey
    :param record: data file to delete (json format)
    :return: num of records deleted
    """
    if record_type == 'contact':
        count = 0
        for i in record:
            try:
                sf.Contact.delete(i)
                count += 1
            except:
                pass
    elif record_type == 'journey':
        count = 0
        for i in record:
            try:
                sf.Opportunity.delete(i)
            except:
                pass
            count += 1
    return str(count) + ' ' + str(record_type) + " deleted"


def json_load(df):
    """
    change a dataframe into json format
    :param df:
    :return: json load
    """
    dict_file = json.dumps(df.to_dict('records'), default=converter)
    load = json.loads(dict_file)
    return load


def run_action(query, con, func, sf):
    """
    run the function of insert or update
    :param query:
    :param con:
    :param func:
    :param sf:
    :return:
    """
    df = pd.read_sql_query(query, con)
    load = json_load(df)
    log, num = func(sf, load)
    return log, num


def main():
    try:
        sf_api = connect_sf()
        print('Salesforce connected')
    except Exception as e:
        print(str(e))
    try:
        engine_sf = connect_sql_server("aou_sf")
        connect = engine_sf.connect()
        print('Sql Server connected')
    except Exception as e:
        print(str(e))
    # Extract contact data from database and save it into backup table
    query_contact = "select top(30) * from [aou_sf].[dbo].[contact] WHERE Id is NULL ORDER BY CH_REDCap_Record_ID__c"
    df_contact = pd.read_sql_query(query_contact, connect)
    df_contact = df_contact.drop(columns=['Id', 'rowsha1'])
    contact_load = json_load(df_contact)
    contact_log_file, num_of_record = insert_contact_sf(sf_api, contact_load)
    save_data(contact_log_file, engine_sf, 'contact_log', 'append')
    root = settings.result_root
    filename = 'error_file_contact_{}.csv'.format(datetime.datetime.now().strftime('%Y-%m-%d-%H%M%S'))
    contact_log_file.to_csv(root + filename, index=False)
    if contact_log_file['Success'].sum() < contact_log_file.shape[0]:
        openfile(root, filename)
    else:
        print("no errors")

    # After correcting data, update data again into salesforce
    query_contact_correct = "select * from [aou_sf].[dbo].[contact_status_error]"
    contact_correct_df = pd.read_sql_query(query_contact_correct, connect)
    while contact_correct_df.shape[0] > 0:
        contact_correct_df = pd.read_sql_query(query_contact_correct, connect)
        save_data(contact_correct_df, engine_sf, 'contact_error', 'replace')
        action = input('Did you fix all the errors? [Y/N]')
        if action.lower() == 'y':
            contact_correct_df = pd.read_sql_query("select * from [aou_sf].[dbo].[contact_error]", connect)
            contact_correct_df = contact_correct_df.drop(['PMI_ID', 'Action', 'Success', 'Error', 'Last_Modified_Time'],
                                                         axis=1)
            contact_correct_load = json_load(contact_correct_df)
            error_file, num_of_record = insert_contact_sf(sf_api, contact_correct_load)
            save_data(error_file, engine_sf, 'contact_log', 'append')
            query_contact_correct = "select * from [aou_sf].[dbo].[contact_status_error]"
            contact_correct_df = pd.read_sql_query(query_contact_correct, connect)

    # Pull Contact_Id and PMI Id from Salesforce and save data into database
    query_contact = sf_api.query("SELECT Id, HP_PMI_ID__c FROM Contact WHERE OwnerId = '{}'".format(settings.OwnerId))
    df_contact_pmi = pd.DataFrame(query_contact['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']
    save_data(df_contact_pmi, engine_sf, 'contact_pmi', 'replace')

    # Extract Journey Id and Contact Id from Salesforce and save data into database
    query_journey_id = sf_api.query("SELECT Id, Contact__c FROM Opportunity WHERE OwnerId = '{}'".format(settings.OwnerId))
    df_journey_contact = pd.DataFrame(query_journey_id['records'])[['Id', 'Contact__c']]
    df_journey_contact.columns = ['Journey_Id', 'Contact_Id']
    save_data(df_journey_contact, engine_sf, 'contact_journey', 'replace')
    print('Relationship Table Updated')

    # Extract journey data from database and update into Salesforce
    query_journey = "select * from [aou_sf].[dbo].[journey]"
    journey_df = pd.read_sql_query(query_journey, connect)
    journey_df = journey_df.drop(columns=['HP_PMI_ID__c', 'Contact__c'])
    journey_load = json_load(journey_df)
    journey_log_file, num_of_record_journey = update_journey_sf(sf_api, journey_load)
    save_data(journey_log_file, engine_sf, 'journey_log', 'append')

    # Save all the contacts and journeys into local database
    contact_sf_query = "SELECT Id,HP_PMI_ID__c,LastName,FirstName,Birthdate,MailingStreet,MailingCity,AccountId," \
                       "MailingState,MailingPostalCode,Email,Phone,HP_Sex__c,HP_Gender_Identity__c," \
                       "HP_Race_Ethnicity__c,CH_All_of_Us_Enroller_UNI__c,CH_REDCap_Record_ID__c," \
                       "CH_Specify_Health_Care_Provider__c,CH_Other_details__c,CH_Technical_Assistance_Required__c," \
                       "CH_How_did_contact_learn_about_AoU__c,CH_Other_technical_assistance_details__c," \
                       "CH_Specify_clinical_outreach__c,NYC_AoU_Status__c,HP_Language__c,CreatedDate,LastModifiedDate" \
                       " FROM Contact WHERE OwnerId = " \
                       "'{}'".format(settings.OwnerId)
    contact_sf = sf_api.query(contact_sf_query)
    df_contact_sf = pd.DataFrame(contact_sf['records']).drop(columns='attributes')
    df_contact_sf = df_contact_sf.fillna('')
    df_contact_sf['MailingState'] = df_contact_sf['MailingState'].apply(lambda x: x.upper())
    save_data(df_contact_sf, engine_sf, 'contact_sf_export', 'replace')

    journey_sf_query = "SELECT Id,Contact__c,AccountId,HP_Participant_Status__c,HP_General_" \
                       "Consent_Status__c,HP_General_Consent_Date__c,HP_EHR_Consent_Status__c,HP_EHR_Consent_Date__c," \
                       "HP_Withdrawal_Date__c,HP_Withdrawal_Status__c,HP_Basics_PPI_Survey_Completion_Date__c," \
                       "HP_Health_PPI_Survey_Completion_Date__c,HP_Lifestyle_PPI_Survey_Completion_Date__c," \
                       "HP_Hist_PPI_Survey_Completion_Date__c,HP_Meds_PPI_Survey_Completion_Date__c," \
                       "HP_Family_PPI_Survey_Completion_Date__c,HP_Access_PPI_Survey_Completion_Date__c," \
                       "HP_Physical_Measurements_Completion_Date__c,HP_Samples_for_DNA_Received__c," \
                       "HP_8_mL_SST_Collection_Date__c,HP_8_mL_PST_Collection_Date__c,HP_4_mL_Na_Hep_Collection_Date__c," \
                       "HP_4_mL_EDTA_Collection_Date__c,HP_1st_10_mL_EDTA_Collection_Date__c," \
                       "HP_2nd_10_mL_EDTA_Collection_Date__c,HP_Saliva_Collection_Date__c," \
                       "HP_Urine_10_ml_Collection_Date__c,HP_2_mL_EDTA_Collection_Date__c," \
                       "HP_Cell_Free_DNA_Collection_Date__c,HP_Paxgene_RNA_Collection_Date__c," \
                       "HP_Urine_90_ml_Collection_Date__c,CreatedDate,LastModifiedDate" \
                       " FROM Opportunity WHERE OwnerId = '{}'".format(settings.OwnerId)

    journey_sf = sf_api.query(journey_sf_query)
    df_journey_sf = pd.DataFrame(journey_sf['records']).drop(columns='attributes')
    save_data(df_journey_sf, engine_sf, 'journey_sf_export', 'replace')

    # Test Environment Delete data
    query_journey_id = sf_api.query("SELECT Id FROM Opportunity WHERE OwnerId = '{}'".format(settings.OwnerId))
    df_journey_contact = pd.DataFrame(query_journey_id['records'])['Id']
    df_journey_contact.columns = ['Journey_Id']
    delete_records(sf_api, 'journey', df_journey_contact)

    query_contact_id = sf_api.query("SELECT Id FROM Contact WHERE OwnerId = '{}'".format(settings.OwnerId))
    df_contact = pd.DataFrame(query_contact_id['records'])['Id']
    df_contact.columns = ['Contact_Id']
    delete_records(sf_api, 'contact', df_contact)


if __name__ == '__main__':
    main()

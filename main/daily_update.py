from simple_salesforce import Salesforce, SalesforceMalformedRequest
from datetime import datetime
from sqlalchemy import create_engine
import json
import pandas as pd
import urllib
import datetime
import os
import sys
import time
sys.path.append('C:\\Users\\xj2193\\PycharmProjects\\sf_uploader\\main')
import settings


def connect_sql_server(database):
    """

    connect database using driver, server and database credentials
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


def connect_sf(schema):
    """

    gain access to Salesforce by passing domain of your Salesforce instance and an access token.
    :return: Salesforce connection
    """
    # NOTE: Once you reset your password, the security token is reset automatically as well.
    # If it's a sandbox, add domain = 'test'
    if schema == 'test':
        sf = Salesforce(username=settings.sf_sandbox_username, password=settings.sf_sandbox_password,
                        security_token=settings.sf_sandbox_security_token, domain='test', version=42.0)
    elif schema == 'prod':
        sf = Salesforce(username=settings.sf_prod_username, password=settings.sf_prod_password,
                        security_token=settings.sf_prod_security_token)
    return sf


def extract_data(engine, sql_file_name):
    """

    read sql file and extract data from DB
    :param engine: DB engine from connect_sql_server function
    :param sql_file_name: sql query to extract data
    :return: pandas dataframe
    """
    connect = engine.connect()
    query = open(os.path.join(settings.path, 'sqlserver/{}'.format(sql_file_name)), 'r')
    sql_file = query.read()
    query.close()
    df = pd.read_sql_query(sql_file, connect)
    return df


def extract_contact_file(sf_api, sqlfile_name, platform_name):
    """

    extract contact file from Salesforce
    :param platform_name: salesforce or pardot
    :return: dataframe
    """
    fd = open(os.path.join(settings.path, 'sqlserver/{}'.format(sqlfile_name)), 'r')
    # path is the parent directory of the daily_update.py file
    if platform_name == 'salesforce':
        sqlfile = fd.read().format(settings.OwnerId, settings.PardotUser)
    elif platform_name == 'pardot':
        sqlfile = fd.read().format(settings.PardotUser)
    else:
        print('wrong platform')
    contact = sf_api.bulk.Contact.query(sqlfile)
    df_contact = pd.DataFrame(contact).drop(columns='attributes')
    df_contact = df_contact.fillna('')
    df_contact['MailingState'] = df_contact['MailingState'].apply(lambda x: x.upper())
    return df_contact


def insert_contact_sf(sf, record):
    """

    loop through contact records and insert into Salesforce
    :param sf: Salesforce connection
    :param record: dataframe of contact records
    :return: how many new records are inserted
    """
    count = 0
    log = pd.DataFrame(columns=['PMI_ID', 'LastName', 'FirstName', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
    for i in record:
        dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'LastName': i['LastName'], 'FirstName': i['FirstName'], 'Action': 'Create'}
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
    """

    update contact records if there's any changes in local DB
    :param sf:
    :param record:
    :return:
    """
    count = 0
    log = pd.DataFrame(columns=['PMI_ID', 'LastName', 'FirstName', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
    for i in record:
        dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'LastName': i['LastName'], 'FirstName': i['FirstName'], 'Action': 'Update'}
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
        print(str(count) + ' of contacts are updated')
    return log, count


def update_journey_sf(sf, record):
    """

    update journey records if there's any changes in local DB
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
            del i['Contact__c']
            sf.Opportunity.update(journey_id, i)
            count += 1
            dict_log['Success'] = 1
            dict_log['Error'] = ''
        except Exception as e:
            print(e)
            dict_log['Success'] = 0
            dict_log['Error'] = "Error message:" + str(e)
        dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log = log.append(dict_log, ignore_index=True)
    print(str(count) + 'journeys are updated')
    return log, count


def extract_journey_file(sf_api, sqlfile_name, platform_name):
    """

    extract journey(opportunity) dataset from salesforce
    :param platform_name: salesforce or pardot
    :return: dataframe
    """
    fd = open(os.path.join(settings.path, 'sqlserver/{}'.format(sqlfile_name)), 'r')
    if platform_name == 'salesforce':
        sqlfile = fd.read().format(settings.OwnerId, settings.PardotUser, settings.SovereignUser)
        # include all participant journeys with owners: user, pardot connector and sovereign CRM
    elif platform_name == 'pardot':
        sqlfile = fd.read().format(settings.PardotUser)
    else:
        print('wrong platform')
    journey = sf_api.bulk.Opportunity.query(sqlfile)
    df_journey = pd.DataFrame(journey).drop(columns='attributes')
    df_journey = df_journey.fillna('')
    return df_journey


def save_data(df, engine, tablename, replace_option):
    """

    save Pandas dataframe in SQL Server
    :param df: dataframe
    :param engine: SQL Server engine
    :param tablename: target table name in DB
    :return: # of records inserted into DB
    """
    df.to_sql(tablename, engine, if_exists=replace_option, index=False)
    conn = engine.connect()
    num_record = pd.read_sql_query('SELECT COUNT(*) FROM %s' % tablename, conn)
    return str(num_record) + ' of records in database inserted'


def converter(o):
    """

    convert datetime type into string to feed in json (function in json.dumps)
    :param o: object
    :return: JSON representation
    """
    if isinstance(o, pd.Timestamp):
        return o.isoformat().__str__()
    # o.strftime('%Y-%m-%d').__str__()
    elif isinstance(o, datetime.date):
        return o.isoformat().__str__()


def delete_records(sf, record_type, record):
    """

    delete records if needed
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


def main():
    try:
        schema = 'prod'
        sf_api = connect_sf(schema)
        print('Salesforce %s connected' % schema)
    except Exception as e:
        print(str(e))
    try:
        engine_sf = connect_sql_server("aou_sf")
        print('Sql Server connected')
    except Exception as e:
        print(str(e))
# ------------------------- Check if the HealthPro data is well loaded ------------------------------------------------#

    contact_amount = extract_data(engine_sf, 'sf_contact_update.sql').shape[0]
    while contact_amount > 1000:
        # Check if the HPO pipeline is well loaded. There might be potential risk when the data is partially loaded. New
        # feature is under development.
        print('The HealthPro API is still working')
        time.sleep(600)
        contact_amount = extract_data(engine_sf, 'sf_contact_update.sql').shape[0]
    else:
        print('HealthPro data is well loaded')
# ------------------------- Extract contacts and journeys from Salesforce and save in local DB ------------------------#

    # extract all salesforce contacts and save it locally
    df_contact_sf = extract_contact_file(sf_api, 'extract_sf_contact.sql', 'salesforce')
    save_data(df_contact_sf, engine_sf, 'v2_sf_contact', 'replace')
    print('sf contact data saved')

    # extract all pardot contacts and save it locally
    df_contact_pardot = extract_contact_file(sf_api, 'extract_pardot_contact.sql', 'pardot')
    save_data(df_contact_pardot, engine_sf, 'v2_pardot_contact', 'replace')
    print('pardot contact data saved')

    # extract all journeys and save it locally
    df_journey_sf = extract_journey_file(sf_api, 'extract_sf_journey.sql', 'salesforce')
    save_data(df_journey_sf, engine_sf, 'v2_sf_journey_export', 'replace')
    print('journey data saved')

# ------------------------- Pull out new dataset from local DB to insert and update in SF -----------------------------#

    # pardot insert
    pardot_contact_update_df = extract_data(engine_sf, 'pardot_contact_update.sql')
    contact_pardot_log_file_update, num_of_pardot_record_update = update_contact_sf(sf_api,
                                                                                    json_load(pardot_contact_update_df))
    save_data(contact_pardot_log_file_update, engine_sf, 'v2_contact_log', 'append')

    # sf insert
    contact_insert_df = extract_data(engine_sf, 'sf_contact_insert.sql')
    contact_insert_df = contact_insert_df.drop(columns=['rowsha1', 'Id'])
    contact_sf_log_file_insert, num_of_sf_record_insert = insert_contact_sf(sf_api, json_load(contact_insert_df))
    save_data(contact_sf_log_file_insert, engine_sf, 'v2_contact_log', 'append')

    # sf update
    contact_update_df = extract_data(engine_sf, 'sf_contact_update.sql')
    contact_update_df = contact_update_df.drop(columns=['rowsha1'])
    contact_sf_log_file_update, num_of_sf_record_update = update_contact_sf(sf_api, json_load(contact_update_df))
    save_data(contact_sf_log_file_update, engine_sf, 'v2_contact_log', 'append')

# --------------------------- Create relationship table of contact, PMI and journey -----------------------------------#

    # Extract Contact_Id and PMI Id from Salesforce and save data into database
    query_contact = sf_api.bulk.Contact.query("SELECT Id, HP_PMI_ID__c FROM Contact WHERE OwnerId = '{}' "
                                              "or OwnerId = '{}'".format(settings.OwnerId, settings.PardotUser))
    df_contact_pmi = pd.DataFrame(query_contact)[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']

    # Extract Journey Id and Contact Id from Salesforce and save data into database
    query_journey_id = sf_api.bulk.Opportunity.query("SELECT Id, Contact__c FROM Opportunity"
                                                     .format(settings.OwnerId, settings.PardotUser))
    df_journey_contact = pd.DataFrame(query_journey_id)[['Id', 'Contact__c']]
    df_journey_contact.columns = ['Journey_Id', 'Contact_Id']

    # Merge contact and journey file together to create a relationship table
    contact_journey_relation = pd.merge(df_contact_pmi, df_journey_contact, how='left', left_on='Contact_Id',
                                        right_on='Contact_Id')
    save_data(contact_journey_relation, engine_sf, 'v2_contact_journey_relation', 'replace')
    print('Relationship Table Updated')

# ------------------------------------------------- Update journey ----------------------------------------------------#
    journey_update_df = extract_data(engine_sf, 'sf_journey_update.sql')
    journey_sf_log_file_update, num_of_sf_journey_update = update_journey_sf(sf_api, json_load(journey_update_df))
    save_data(journey_sf_log_file_update, engine_sf, 'v2_journey_log', 'append')
    print('journey updated')

    # update withdrawn participants
    withdrawal_df = extract_data(engine_sf, 'withdrawal_participant_test.sql')
    withdrawal_df_update = withdrawal_df[['Id', 'Contact__c', 'HP_Withdrawal_Date__c', 'HP_Withdrawal_Status__c']]
    withdrawal_log_file_update, num_of_withdrawal_update = update_journey_sf(sf_api, json_load(withdrawal_df_update))
    save_data(withdrawal_log_file_update, engine_sf, 'v2_journey_log', 'append')
    print('withdrawal status updated')

    # extract all salesforce contacts and save it locally again
    df_contact_sf = extract_contact_file(sf_api, 'extract_sf_contact.sql', 'salesforce')
    save_data(df_contact_sf, engine_sf, 'v2_sf_contact', 'replace')
    print('sf contact data saved')

    # extract all pardot contacts and save it locally
    df_contact_pardot = extract_contact_file(sf_api, 'extract_pardot_contact.sql', 'pardot')
    save_data(df_contact_pardot, engine_sf, 'v2_pardot_contact', 'replace')
    print('pardot contact data saved')

    # extract all journeys and save it locally
    df_journey_sf = extract_journey_file(sf_api, 'extract_sf_journey.sql', 'salesforce')
    save_data(df_journey_sf, engine_sf, 'v2_sf_journey_export', 'replace')
    print('journey data saved')

    return print('{} of contacts inserted \n '
                 '{} of contacts updated \n '
                 '{} of pardot records updated \n '
                 '{} of journeys updated \n '
                 '{} of withdrawals updated \n'.format(num_of_sf_record_insert, num_of_sf_record_update,
                                                       num_of_pardot_record_update, num_of_sf_journey_update,
                                                       num_of_withdrawal_update))


if __name__ == '__main__':
    main()

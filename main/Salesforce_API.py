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
    print(str(count) + '/' + str(len(record[0]) + ' of contacts are inserted'))
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
    print(str(count) + '/' + str(len(record[0])) + 'journeys are updated')
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
    if isinstance(o, datetime.date):
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
    query_contact = "select top(30) * into tem_table from [aou_sf].[dbo].[contact] WHERE Contact_Id is NULL " \
                    "alter table tem_table drop column Contact_Id" \
                    "select * from tem_table" \
                    "drop table tem_table"
    contact_log_file, num_of_record = run_action(query_contact, connect, insert_contact_sf, sf_api)
    save_data(contact_log_file, engine_sf, 'contact_log', 'append')
    root = settings.result_root
    contact_log_file.to_csv(root + 'error_file_contact_{}.csv'.format(datetime.datetime.now()
                                                                      .strftime('%Y-%m-%d %H:%M:%S')), index=False)
    if contact_log_file.shape[0] > 1:
        openfile(root, 'error_file.csv')
    else:
        print("no errors")

    # after correcting data, update data again into salesforce
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
            save_data(error_file, engine_sf, 'error_log', 'append')
            query_contact_correct = "select * from [aou_sf].[dbo].[contact_status_error]"
            contact_correct_df = pd.read_sql_query(query_contact_correct, connect)

    # pull Contact_Id and PMI Id from Salesforce and save data into database
    query_contact = sf_api.query("SELECT Id, HP_PMI_ID__c FROM Contact WHERE OwnerId = '0050a00000L0eZPAAZ'")
    df_contact_pmi = pd.DataFrame(query_contact['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']
    save_data(df_contact_pmi, engine_sf, 'contact_pmi', 'replace')

    # extract Journey Id and Contact Id from Salesforce and save data into database
    query_journey_id = sf_api.query("SELECT Id, Contact__c FROM Opportunity WHERE OwnerId = '0050a00000L0eZPAAZ'")
    df_journey_contact = pd.DataFrame(query_journey_id['records'])[['Id', 'Contact__c']]
    df_journey_contact.columns = ['Journey_Id', 'Contact_Id']
    save_data(df_journey_contact, engine_sf, 'contact_journey', 'replace')
    print('Relationship Table Updated')

    # extract journey data from database and update into Salesforce
    query_journey = "select * from [aou_sf].[dbo].[journey]"
    journey_df = pd.read_sql_query(query_journey, connect)
    journey_df = journey_df.drop(columns=['HP_PMI_ID__c', 'Contact__c'])
    journey_load = json_load(journey_df)
    journey_log_file, num_of_record_journey = update_journey_sf(sf_api, journey_load)
    save_data(journey_log_file, engine_sf, 'journey_log', 'append')
    print(str(num_of_record_journey) + '/' + str(journey_df.shape[0]) + ' journeys are updated')


if __name__ == '__main__':
    main()

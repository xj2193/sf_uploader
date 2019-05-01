from simple_salesforce import Salesforce
from sqlalchemy import create_engine
import pandas as pd
import urllib
import settings
import datetime
import json


def connect_sql_server():
    """

    Connect database using driver, server and database credentials
    :return: engine
    """
    # NOTE: It uses your windows authentication to connect to SQL Server so please be sure you have the access to DB
    conn_str = (
        r'Driver={};'
        r'Server={};'
        r'Database={};'
        r'Trusted_Connection=yes;'.format(settings.Driver, settings.Server, settings.Database)
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
    for i in record:
        try:
            sf.Contact.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' contacts inserted')


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
    for i in record:
        journey_id = i['Id']
        try:
            del i['Id']
            sf.Opportunity.update(journey_id, i)
            count += 1
        except:
            pass
    return print(str(count) + ' journeys updated')


def save_data(df, engine, tablename):
    """

    Save Pandas dataframe into SQL Server
    :param df: dataframe
    :param engine: SQL Server engine
    :param tablename: target table name in DB
    :return: how many records are inserted into DB
    """
    df.to_sql(tablename, engine, if_exists='replace', index=False)
    conn = engine.connect()
    num_record = pd.read_sql_query('SELECT Count(*) FROM %s' % tablename, conn)
    return str(num_record) + ' of records in database inserted'


def converter(o):
    """

    Convert datetime type into string to feed in json (function in json.dumps)
    :param o: object
    :return: JSON representation
    """
    if isinstance(o, datetime.date):
        return o.__str__()


def main():
    sf_api = connect_sf()
    print('Salesfroce connected')
    # extract contact data from database and insert into Salesforce
    engine = connect_sql_server()
    print('Sql Server connected')
    contact_df = extract_data(engine, 'sf_contact.sql')
    contact_dict = contact_df.to_dict('records')
    insert_contact_sf(sf_api, contact_dict)
    # pull Contact_Id and PMI Id from Salesforce and save data into database 
    query_contact = sf_api.query('SELECT Id, HP_PMI_ID__c FROM Contact')
    df_contact_pmi = pd.DataFrame(query_contact['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']
    save_data(df_contact_pmi, engine, 'Contact_PMI')
    # extract Journey Id and Contact Id from Salesforce and save data into database
    query_journey = sf_api.query('SELECT Id, Contact__c FROM Opportunity')
    df_journey_contact = pd.DataFrame(query_journey['records'])[['Id', 'Contact__c']]
    df_journey_contact.columns = ['Journey_Id', 'Contact_Id']
    save_data(df_journey_contact, engine, 'Contact_Journey')
    # truncate relationship table and insert new data
    connect = engine.connect()
    query = open('relationship.sql', 'r')
    sql_file = query.read()
    query.close()
    connect.execute(sql_file)
    connect.close()
    print('Relationship Table Updated')
    # extract journey data from database and update into Salesforce
    journey_df = extract_data(engine, 'sf_journey.sql')
    journey_df_merge = journey_df.merge(df_journey_contact)
    journey_df_merge.rename(columns={'Contact_Id': 'Contact__c', 'Journey_Id': 'Id'}, inplace=True)
    journey_df_merge = journey_df_merge.drop(columns=['HP_PMI_ID__c', 'Contact__c'])
    journey_dict = json.dumps(journey_df_merge.to_dict('records'), default=converter)
    journey_load = json.loads(journey_dict)
    update_journey_sf(sf_api, journey_load)


if __name__ == '__main__':
    main()

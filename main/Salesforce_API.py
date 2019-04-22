from simple_salesforce import Salesforce
from sqlalchemy import create_engine
import pyodbc
import pandas as pd
import urllib


# Connect to SQL Server --- AOUSQL
def connect_sql_server():
    conn_str = (
        r'Driver=ODBC Driver 13 for SQL Server;'
        r'Server=aousql.dbmi.columbia.edu;'
        r'Database=aou_sf;'
        r'Trusted_Connection=yes;'
    )
    quoted_conn_str = urllib.parse.quote_plus(conn_str)
    engine = create_engine('mssql+pyodbc:///?odbc_connect={}'.format(quoted_conn_str))
    return engine


# Connect to Salesforce Sandbox (DataLoad)
def connect_sf(password):
    sf = Salesforce(username='djb2188@cumc.columbia.edu.DataLoad', password=password,
                    security_token='BFFOPYZ1SGJN0Bu8gcs6LuYYS', domain='test', version=42.0)
    return sf


# Read SQL query and extract data from database
def extract_data(engine, sql_file_name):
    connect = engine.connect()
    query = open(sql_file_name, 'r')
    sql_file = query.read()
    query.close()
    df = pd.read_sql_query(sql_file, connect)
    return df


# Insert contact record into Salesforce Sandbox
def insert_contact_sf(sf, record):
    count = 0
    for i in record:
        try:
            sf.Contact.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' contacts inserted')


# Insert journey record into Salesforce Sandbox
def insert_journey_sf(sf, record):
    count = 0
    for i in record:
        try:
            sf.Opportunity.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' journeys inserted')


# Updade existing journey into Salesforce Sandbox
def update_journey_sf(sf, record):
    count = 0
    for i in record:
        journey_id = i['Journey_Id']
        try:
            del i['Journey_Id']
            sf.Opportunity.update(journey_id, i)
            count += 1
        except:
            pass
    return print(str(count) + ' journeys updated')


'''def bulk_insert_sf(sf, record):
    count = 0
    try:
        sf.bulk.Contact.insert(record)
        count = str(len(record))
    except:
        pass
    return print('Bulk insert ' + count + ' records')
'''


# Save datafrome into SQL Server table
def save_data(df, engine, tablename):
    df.to_sql(tablename, engine, if_exists='replace', index=False)
    conn = engine.connect()
    num_record = pd.read_sql_query('SELECT Count(*) FROM %s' % tablename, conn)
    return str(num_record) + ' of records in database inserted'


def main():
    pw = 'DBM2@oU19' # Sandbox password for Salesforce
    sf_api = connect_sf(pw)
    print('Salesfroce connected')
    # extract contact data from database and insert into Salesforce
    engine = connect_sql_server()
    print('Sql Server connected')
    contact_df = extract_data(engine, 'sf_code.sql')
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
    # drop relationship table and insert new data
    connect = engine.connect()
    query = open('Relationship.sql', 'r')
    sql_file = query.read()
    query.close()
    connect.execute(sql_file)
    print('Relationship Table Updated')
    # extract journey data from database and update into Salesforce
    journey_df = extract_data(engine, 'journey_sf_code.sql')
    journey_df_merge = journey_df.merge(df_journey_contact)
    journey_df_merge = journey_df_merge.drop(columns=['HP_PMI_ID__c'])
    journey_dict = journey_df_merge.to_dict('records')
    update_journey_sf(sf_api, journey_dict)


main()

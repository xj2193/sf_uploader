from simple_salesforce import Salesforce
from sqlalchemy import create_engine
import pyodbc
import pandas as pd
import urllib


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


def connect_sf(password):
    sf = Salesforce(username='djb2188@cumc.columbia.edu.DataLoad', password=password,
                    security_token='IEEwFPkZVGLXjRkLQH1JyRlM', domain='test', version=42.0)
    return sf


def extract_data(engine, sql_file_name):
    connect = engine.connect()
    #connect = connect_sql_server('aousql.dbmi.columbia.edu', 'dm_aou')[0]
    query = open(sql_file_name, 'r')
    sql_file = query.read()
    query.close()
    df = pd.read_sql_query(sql_file, connect)
    return df


def insert_contact_sf(sf, record):
    count = 0
    for i in record:
        try:
            sf.Contact.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' contacts inserted')


def insert_journey_sf(sf, record):
    count = 0
    for i in record:
        try:
            sf.Opportunity.create(i)
            count += 1
        except:
            pass
    return print(str(count) + ' journeys inserted')


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


def bulk_insert_sf(sf, record):
    count = 0
    try:
        sf.bulk.Contact.insert(record)
        count = str(len(record))
    except:
        pass
    return print('Bulk insert ' + count + ' records')


def save_data(df, engine, tablename):
    df.to_sql(tablename, engine, if_exists='replace', index=False)
    conn = engine.connect()
    num_record = pd.read_sql_query('SELECT Count %s' % tablename, conn)
    return str(num_record) + ' of records in database inserted'


def main():
    pw = 'DBM1@oU19'
    sf_api = connect_sf(pw)

    contact_df = extract_data('sf code.sql')
    contact_dict = contact_df.to_dict('records')
    insert_contact_sf(sf_api, contact_dict)

    query_contact = sf_api.query('SELECT Id, HP_PMI_ID__c FROM Contact')
    df_contact_pmi = pd.DataFrame(query_contact['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact_Id', 'PMI_Id']
    save_data(df_contact_pmi, 'Contact_PMI')

    query_journey = sf_api.query('SELECT Id, Contact__c FROM Opportunity')
    df_journey_contact = pd.DataFrame(query_journey['records'])[['Id', 'Contact__c']]
    df_journey_contact.columns = ['Journey_Id', 'Contact_Id']
    save_data(df_journey_contact, 'Contact_Journey')

    engine = connect_sql_server()
    connect = engine.connect()
    query = open('Relationship.sql', 'r')
    sql_file = query.read()
    query.close()
    connect.execute(sql_file)

    journey_df = extract_data(engine, 'journey sf code.sql')
    journey_df_merge = journey_df.merge(df_journey_contact)
    #journey_df_merge = journey_df.merge(df_contact_pmi, how='left', on='HP_PMI_ID__c')
    journey_df_merge = journey_df_merge.drop(columns=['HP_PMI_ID__c'])
    journey_dict = journey_df_merge.to_dict('records')

    update_journey_sf(sf_api, journey_dict)


main()




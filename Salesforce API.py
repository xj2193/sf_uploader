from simple_salesforce import Salesforce
from sqlalchemy import create_engine
import pyodbc
import pandas as pd


def connect_sql_server(server_name, database_name):
    connect = pyodbc.connect(driver='{SQL Server}', server=server_name, database=database_name, trusted_connection='yes')
    cursor = connect.cursor()
    return connect, cursor


def connect_sf(password):
    sf = Salesforce(username='djb2188@cumc.columbia.edu.DataLoad', password=password,
                    security_token='IEEwFPkZVGLXjRkLQH1JyRlM', domain='test', version=42.0)
    return sf


def extract_data(sql_file_name):
    connect = connect_sql_server('aousql.dbmi.columbia.edu', 'dm_aou')[0]
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


def bulk_insert_sf(sf, record):
    count = 0
    try:
        sf.bulk.Contact.insert(record)
        count = str(len(record))
    except:
        pass
    return print('Bulk insert ' + count + ' records')


def save_data(sf, tablename, column_names):
    query_ls = sf.query('SELECT Id, HP_PMI_ID__c FROM Contact')
    df_contact_pmi = pd.DataFrame(query_ls['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = column_names
    engine = create_engine('mssql://aousql.dbmi.columbia.edu/dm_aou?trusted_connection=yes')
    df_contact_pmi.to_sql(tablename, engine, if_exists='replace')
    connect, cursor = connect_sql_server('aousql.dbmi.columbia.edu', 'dm_aou')
    num_record = pd.read_sql_query('SELECT count(*) from %s' % tablename, connect)
    return str(num_record) + ' of records in database inserted'


def main():
    pw = input('Please enter the password: ')
    sf_api = connect_sf(pw)

    contact_df = extract_data('sf code.sql')
    contact_dict = contact_df.to_dict('records')
    insert_contact_sf(sf_api, contact_dict)

    query_ls = sf_api.query('SELECT Id, HP_PMI_ID__c FROM Contact')
    df_contact_pmi = pd.DataFrame(query_ls['records'])[['Id', 'HP_PMI_ID__c']]
    df_contact_pmi.columns = ['Contact__c', 'HP_PMI_ID__c']

    journey_df = extract_data('journey sf code.sql')
    journey_df_merge = journey_df.merge(df_contact_pmi, how='left', on='HP_PMI_ID__c')
    journey_df_merge = journey_df_merge.drop(columns=['HP_PMI_ID__c'])
    journey_dict = journey_df_merge.to_dict('records')

    insert_journey_sf(sf_api, journey_dict)
    return 'Insert done haha'


main()




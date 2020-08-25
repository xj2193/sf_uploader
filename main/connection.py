import pandas as pd
from simple_salesforce import Salesforce
from sqlalchemy import create_engine
import urllib


def connect_sql_server(config_file, database):
    """
    connect database using driver, server and database credentials
    :return: engine
    """
    # NOTE: It uses your windows authentication to connect to SQL Server so please be sure you have the access to DB
    conn_str = (
        r'Driver={};'
        r'Server={};'
        r'Database={};'
        r'UID={};'
        r'pwd={};'.format(config_file['driver'], config_file['server'], database, config_file['uid'], config_file['pwd'])
    )
    quoted_conn_str = urllib.parse.quote_plus(conn_str)
    engine = create_engine('mssql+pyodbc:///?odbc_connect={}'.format(quoted_conn_str))
    #connection = engine.connect()
    return engine


def execute_sql_query(conn, query):
    df = pd.read_sql_query(sql=query, con=conn)
    return df


def connect_sf(schema, sf_config_file):
    """

    gain access to Salesforce by passing domain of your Salesforce instance and an access token.
    :return: Salesforce connection
    """
    # NOTE: Once you reset your password, the security token is reset automatically as well.
    # If it's a sandbox, add domain = 'test'
    if schema == 'test':
        sf = Salesforce(username=sf_config_file['sf_sandbox_username'], password=sf_config_file['sf_sandbox_password'],
                        security_token=sf_config_file['sf_sandbox_security_token'], domain='test', version=42.0)
    elif schema == 'prod':
        sf = Salesforce(username=sf_config_file['sf_prod_username'], password=sf_config_file['sf_prod_password'],
                        security_token=sf_config_file['sf_prod_security_token'])
    return sf

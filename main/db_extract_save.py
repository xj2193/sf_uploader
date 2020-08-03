import pandas as pd


def extract_data_db(conn, sql_file_name):
    query = open('./sqlserver/{}'.format(sql_file_name), 'r')
    sql_file = query.read()
    query.close()
    df = pd.read_sql_query(sql_file, conn)
    return df


def save_data(conn, df, table_name, replace_option):
    df.to_sql(table_name, conn, if_exists=replace_option, index=False)
    num_record = pd.read_sql_query('SELECT COUNT(*) FROM %s' % table_name, conn).iloc[0][0]
    return '{} of records inserted in {}'.format(str(num_record), table_name)
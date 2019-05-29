from salesforce_api import *
import pandas as pd

# Connect to database and salesforce


def extract_update_data(database, schema, table, columns_to_drop, status, connect):
    if status == 'new':
        query = "select top 30 * from [{}].[{}].[{}] where Id is null".format(database, schema, table)
    elif status == 'exist':
        query = "select top 30 * from [{}].[{}].[{}] where Id is not null".format(database, schema, table)
    df = pd.read_sql_query(query, connect)
    df = df.drop(columns_to_drop, axis=1)
    return df


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

    # Extract contact data from database

    df_contact_insert = extract_update_data('aou_sf', 'dbo', 'contact_new', ['rowsha1', 'Id'], 'new', connect)
    df_contact_update = extract_update_data('aou_sf', 'dbo', 'contact_new', ['rowsha1', 'Id'], 'exist', connect)
    contact_load_insert = json_load(df_contact_insert)
    contact_load_update = json_load(df_contact_update)
    contact_log_file_insert, num_of_contact_insert = insert_contact_sf(sf_api, contact_load_insert)
    contact_log_file_update, num_of_contact_update = update_contact_sf(sf_api, contact_load_update)
    save_data(contact_log_file_insert, engine_sf, 'contact_log', 'append')
    filename_new = 'error_file_contact_upsert_{}.csv'.format(datetime.datetime.now().strftime('%Y-%m-%d-%H%M%S'))
    root = settings.result_root
    contact_log_file_upsert = contact_log_file_insert.append(contact_log_file_update)
    contact_log_file_upsert.to_csv(root + filename_new, index=False)
    if contact_log_file_upsert.shape[0] > 1:
        openfile(root, filename_new)
    else:
        print("no errors")

    df_journey_update = extract_update_data('aou_sf', 'dbo', 'journey_new', ['rowsha1', 'Id'], 'new', connect)
    journey_load_update = json_load(df_journey_update)

    journey_log_file_update, num_of_journey_update = update_journey_sf(sf_api, journey_load_update)
    save_data(journey_log_file_update, engine_sf, 'journey_log', 'append')


if __name__ == '__main__':
    main()










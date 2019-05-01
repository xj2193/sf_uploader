def update_contact_sf(sf, record):
    """

    :param sf:
    :param record:
    :return:
    """
    count = 0
    for i in record:
        contact_id = i['Id']
        del i['Id']
        print(contact_id, i)
        sf.Contact.update(contact_id, i)
        '''try:
            del i['Id']
            sf.Contact.update(contact_id, i)
            count += 1
        except:
            pass'''
        return print(str(count) + ' contacts updated')

# update contact data from
contact_df_update = contact_df.merge(df_contact_pmi, left_on='HP_PMI_ID__c', right_on='PMI_Id', how='right')
contact_df_update.rename(columns={'Contact_Id': 'Id'}, inplace=True)
contact_df_update = contact_df_update.drop(columns=['PMI_Id'])
contact_df_update_dict = json.dumps(contact_df_update.to_dict('records'), default=converter)
contact_df_load = json.loads(contact_df_update_dict)
update_contact_sf(sf_api, contact_df_load)
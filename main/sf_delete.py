def delete_records(sf_api, record_type, record):
    """

    delete records if needed
    :param sf_api: Salesforce Connection
    :param record_type: Contact or Journey
    :param record: data file to delete (json format)
    :return: num of records deleted
    """
    if record_type.lower() == 'contact':
        count = 0
        for i in record:
            try:
                sf_api.Contact.delete(i['Id'])
                count += 1
            except:
                pass
    elif record_type.lower() == 'opportunity':
        count = 0
        for i in record:
            try:
                sf_api.Opportunity.delete(i['Id'])
                count += 1
            except:
                pass
    return str(count) + ' ' + str(record_type) + " deleted"

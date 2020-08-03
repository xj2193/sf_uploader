import pandas as pd
from simple_salesforce import SalesforceMalformedRequest
from datetime import datetime


class InsertRecord:

    def __init__(self, sf_api, record):
        self.sf_api = sf_api
        self.record = record

    def insert_contact_sf(self):
        count = 0
        log = pd.DataFrame(columns=['PMI_ID', 'LastName', 'FirstName', 'Action', 'Success', 'Error',
                                    'Last_Modified_Time'])
        for i in self.record:
            dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'LastName': i['LastName'], 'FirstName': i['FirstName'],
                        'Action': 'Create'}
            try:
                self.sf_api.Contact.create(i)
                dict_log['Success'] = 1
                dict_log['Error'] = ''
                count += 1
            except SalesforceMalformedRequest as e:
                dict_log['Success'] = 0
                dict_log['Error'] = "Error message:" + e.content[0]['message']
            dict_log['Last_Modified_Time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            log = log.append(dict_log, ignore_index=True)
        print(str(count) + ' contacts are inserted')
        return log, count

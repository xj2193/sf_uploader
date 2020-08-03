import pandas as pd
import datetime


class UpdateRecord:
    def __init__(self, sf_api, record):
        self.sf_api = sf_api
        self.record = record

    def update_contact_records(self):
        count = 0
        log = pd.DataFrame(columns=['PMI_ID', 'LastName', 'FirstName', 'Action', 'Success', 'Error',
                                        'Last_Modified_Time'])
        for i in self.record:
            dict_log = {'PMI_ID': i['HP_PMI_ID__c'], 'LastName': i['LastName'], 'FirstName': i['FirstName'],
                        'Action': 'Update'}
            contact_id = i['Id']
            del i['Id']
            try:
                self.sf_api.Contact.update(contact_id, i)
                count += 1
                dict_log['Success'] = 1
                dict_log['Error'] = ''
            except Exception as e:
                dict_log['Success'] = 0
                dict_log['Error'] = "Error message:" + str(e)
            dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            log = log.append(dict_log, ignore_index=True)
        if len(self.record) == 0:
            print('0 contact is updated')
        else:
            print(str(count) + ' contacts are updated')
        return log, count

    def update_journey_records(self):
        count = 0
        log = pd.DataFrame(columns=['Journey_Id', 'Action', 'Success', 'Error', 'Last_Modified_Time'])
        for i in self.record:
            dict_log = {'Journey_Id': i['Id'], 'Action': 'Update'}
            journey_id = i['Id']
            try:
                del i['Id']
                del i['Contact__c']
                self.sf_api.Opportunity.update(journey_id, i)
                count += 1
                dict_log['Success'] = 1
                dict_log['Error'] = ''
            except Exception as e:
                print(e)
                dict_log['Success'] = 0
                dict_log['Error'] = "Error message:" + str(e)
            dict_log['Last_Modified_Time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            log = log.append(dict_log, ignore_index=True)
        print(str(count) + ' journeys are updated')
        return log, count

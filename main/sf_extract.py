import pandas as pd


class SFDataExtraction:

    def __init__(self, sf_api, sql_file_name, platform, object, sf_settings):
        self.sf_api = sf_api
        self.sql_file_name = sql_file_name
        self.platform = platform
        self.object = object
        self.sf_settings = sf_settings

    def extract_data_sf(self):
        """

        extract contact file from salesforce
        :return: dataframe
        """

        fd = open('./sqlserver/{}'.format(self.sql_file_name), 'r')
        if self.platform == 'salesforce':
            query_file = fd.read().format(self.sf_settings['ownerid'], self.sf_settings['pardotuser1'],
                                          self.sf_settings['pardotuser2'], self.sf_settings['sovereignuser'])
        elif self.platform == 'pardot':
            query_file = fd.read().format(self.sf_settings['pardotuser1'], self.sf_settings['pardotuser2'])
        else:
            print('wrong platform')
        if self.object.lower() == "contact":
            contact = self.sf_api.bulk.Contact.query(query_file)
            df_contact = pd.DataFrame(contact).drop(columns='attributes')
            df_contact = df_contact.fillna('')
            df_contact['MailingState'] = df_contact['MailingState'].apply(lambda x: x.upper())
            return df_contact
        elif self.object.lower() == "opportunity":
            journey = self.sf_api.bulk.Opportunity.query(query_file)
            df_journey = pd.DataFrame(journey).drop(columns='attributes')
            df_journey = df_journey.fillna('')
            return df_journey

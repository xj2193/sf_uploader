from data_converter import json_load
import math


class SFBulk:
    def __init__(self, sf_api, df, sf_object, batch_size, action):
        self.sf_api = sf_api
        self.df = df
        self.sf_object = sf_object
        self.batch_size = batch_size
        self.action = action

    def bulk_func(self, batch_df):
        if self.sf_object.lower() == 'contact':
            if self.action.lower() == 'insert':
                self.sf_api.bulk.Contact.insert(json_load(batch_df))
            elif self.action.lower() == 'update':
                self.sf_api.bulk.Contact.update(json_load(batch_df))

        elif self.sf_object.lower() == 'opportunity':
            if self.action.lower() == 'insert':
                self.sf_api.bulk.Opportunity.insert(json_load(batch_df))
            elif self.action.lower() == 'update':
                self.sf_api.bulk.Opportunity.update(json_load(batch_df))

        else:
            print('The object is not supported by bulk')

    def bulk_upsert(self):
        try:
            batch = math.ceil(self.df.shape[0] / self.batch_size)
            i = 0
            while i < (batch - 1):
                point = i * self.batch_size
                data_batch = self.df.iloc[point:point + self.batch_size, :]
                self.bulk_func(data_batch)
                i += 1
            else:
                point = i * self.batch_size
                data_batch = self.df.iloc[point:, :]
                self.bulk_func(data_batch)
        except Exception as e:
            print(e)
        return 'bulk {}ed {} {}'.format(self.action, str(self.df.shape[0]), self.sf_object)

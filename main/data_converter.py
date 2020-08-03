import pandas as pd
import datetime
import json


def converter(o):
    """

    convert datetime type into string to feed in json (function in json.dumps)
    :param o: object
    :return: JSON representation
    """
    if isinstance(o, pd.Timestamp):
        return o.isoformat().__str__()
    elif isinstance(o, datetime.date):
        return o.isoformat().__str__()


def json_load(df):
    """

    change a dataframe into json format
    :param df:
    :return: json load
    """
    dict_file = json.dumps(df.to_dict('records'), default=converter)
    load = json.loads(dict_file)
    return load



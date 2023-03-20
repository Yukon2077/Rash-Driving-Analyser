import pandas as pd


data = pd.read_csv('driving_data.csv')

data['datetime'] = pd.to_datetime(data['datetime'])

data = data.groupby([pd.Grouper(key='datetime', freq='D')]).sum().reset_index()
data['number_of_incidents'] = data['is_rash']
data = data[['datetime', 'number_of_incidents']]
data = data.reset_index(drop=True)
data.to_csv('preprocessed_data.csv', index=False)

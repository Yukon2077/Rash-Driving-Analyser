import pickle
import pandas as pd

"""with open('model.pickle', 'rb') as data_file:
    model = pickle.load(data_file)

input_data = {'driving_vehicle_speed':80.1, 'nearby_vehicle_speed':80.2, 'nearby_vehicle_distance':4}

result = model.predict(pd.DataFrame(input_data, index=[0]))[0]"""

features = ['driving_vehicle_speed', 'nearby_vehicle_speed', 'nearby_vehicle_distance']

data_csv = pd.read_csv('driving_data.csv')

with open('model.pickle', 'rb') as data_file:
  model = pickle.load(data_file)
data_csv['is_rash'] = model.predict(data_csv[features])

data_csv['is_rash'] = data_csv['is_rash'].astype(int)

data_csv.to_csv('driving_data.csv', index=False)
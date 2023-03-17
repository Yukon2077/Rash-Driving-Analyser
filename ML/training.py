import pandas as pd
from sklearn.model_selection import train_test_split    
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import pickle

csv = pd.read_csv('driving_dataset.csv')

features = ['driving_vehicle_speed', 'nearby_vehicle_speed', 'nearby_vehicle_distance']

print()
print(csv.loc[:,['driving_vehicle_speed', 'nearby_vehicle_speed', 'nearby_vehicle_distance']].to_string())
print()

csv['driving_vehicle_speed'] = round(csv['driving_vehicle_speed'] * 1000 / 3600, 2)
csv['nearby_vehicle_speed'] = round(csv['nearby_vehicle_speed'] * 1000 / 3600, 2)
csv['TTC'] = csv['nearby_vehicle_distance']/(csv['driving_vehicle_speed'] - csv['nearby_vehicle_speed'])
csv['is_rash'] = (csv['TTC'] <= 2 ) & (csv['driving_vehicle_speed'] > csv['nearby_vehicle_speed'])

print()
print(csv.loc[:,['driving_vehicle_speed', 'nearby_vehicle_speed', 'nearby_vehicle_distance', 'TTC', 'is_rash']].to_string())
print()

X = csv[features]
Y = csv['is_rash']

x_train, x_test, y_train, y_test = train_test_split(X, Y)

model = RandomForestClassifier()
model.fit(x_train, y_train)

y_pred = model.predict(x_test)

accuracy = accuracy_score(y_test, y_pred)

print(accuracy)

with open('model.pickle', 'wb') as data_file:
    pickle.dump(model, data_file)

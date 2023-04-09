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

import matplotlib.pyplot as plt
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score

# assuming y_test and y_pred are binary labels for a classification problem
accuracy = accuracy_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred)
precision = precision_score(y_test, y_pred)
recall = recall_score(y_test, y_pred)

metrics = [accuracy, f1, precision, recall]
metric_names = ['Accuracy', 'F1 Score', 'Precision', 'Recall']

# create bar chart
fig, ax = plt.subplots()
ax.bar(metric_names, metrics, color='green')

# add labels and title
ax.set_xlabel('Metrics')
ax.set_ylabel('Score')
ax.set_title('Model Evaluation Metrics')

# add numbers to bars
for i, v in enumerate(metrics):
    ax.text(i, v + 0.01, str(round(v, 3)), ha='center')

# show plot
plt.show()

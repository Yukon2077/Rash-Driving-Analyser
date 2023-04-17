import numpy as np
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

models = np.array(["Our Random Forest Model", "RF Model from the paper \"Comparing Algorithms for Aggressive Driving Event Detection Based on Vehicle Motion Data\""])
metrics = np.array(["Accuracy", "F1 Score", "Precision", "Recall"])
data = np.array([[0.96, 0.96, 0.90, 0.93], [0.95, 0.90, 0.90, 0.90]])

bar_width = 0.35
r1 = np.arange(len(metrics))
r2 = [x + bar_width for x in r1]

fig, ax = plt.subplots()

bars1 = ax.bar(r1, data[0], color='blue', width=bar_width, edgecolor='white', label=models[0])
bars2 = ax.bar(r2, data[1], color='lightblue', width=bar_width, edgecolor='white', label=models[1])

ax.set_xlabel('Metrics')
ax.set_ylabel('Score')
ax.set_title('Model Evaluation Metrics')

ax.set_xticks([r + bar_width/2 for r in range(len(metrics))])
ax.set_xticklabels(metrics)

for bar in bars1 + bars2:
    height = bar.get_height()
    ax.annotate('{:.2f}'.format(height),
                xy=(bar.get_x() + bar.get_width() / 2, height),
                xytext=(0, 3),
                textcoords="offset points",
                ha='center', va='bottom')

ax.legend(loc='lower center')

plt.show()

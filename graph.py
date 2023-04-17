from matplotlib import pyplot as plt
import numpy as np
import textwrap


models = np.array(["Our Random Forest Model", 
                   "RF Model from the paper \"Comparing Algorithms for Aggressive Driving Event Detection Based on Vehicle Motion Data\"",
                   "Decision Tree from the paper \"A Machine Learning-Based Defensive Alerting System Against Reckless Driving in Vehicular Networks\"",
                   "YOLO model from \"Autonomous Reckless Driving Detection Using Deep Learning on Embedded GPUs\""])
metrics = np.array(["Accuracy", "F1 Score", "Precision", "Recall"])
data = np.array([[0.96, 0.96, 0.90, 0.93], [0.95, 0.90, 0.90, 0.90]])

data = np.array([[0.96, 0.95, 0.93, 0.91], 
                 [0.96, 0.90, 0.89, 0.88],
                 [0.90, 0.90, 0.99, 0.80],
                 [0.93, 0.90, 0.93, 1.00]])

wrapped_labels = [textwrap.fill(label, 34) for label in models]

x = 3
plt.bar(models, data[x])
plt.xlabel(metrics[x])
plt.ylabel('Score')
plt.title(metrics[x])
plt.xticks(labels=wrapped_labels, ticks=[0, 1, 2, 3])

for i, score in enumerate(data[x]):
    plt.text(i, score+0.01, f"{score:.2f}", ha='center')

plt.show()
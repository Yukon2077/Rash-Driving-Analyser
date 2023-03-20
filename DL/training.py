from sklearn.metrics import accuracy_score, recall_score, f1_score
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from keras.models import Sequential
from keras.layers import LSTM, Dense

df = pd.read_csv('preprocessed_data.csv', parse_dates=['datetime'])
df = df.set_index('datetime')
print(df.head())

scaler = MinMaxScaler(feature_range=(0, 1))
data = scaler.fit_transform(df)

train_data, test_data = train_test_split(data, shuffle=False, stratify=None)


def create_dataset(data, look_back=1):
    X, Y = [], []
    for i in range(len(data)-look_back):
        X.append(data[i:(i+look_back)])
        Y.append(data[i + look_back])
    return np.array(X), np.array(Y)


look_back = 1
train_X, train_Y = create_dataset(train_data, look_back)
test_X, test_Y = create_dataset(test_data, look_back)

train_X = np.reshape(train_X, (train_X.shape[0], train_X.shape[1], 1))
test_X = np.reshape(test_X, (test_X.shape[0], test_X.shape[1], 1))

model = Sequential()
model.add(LSTM(50, input_shape=(look_back, 1)))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam')

history = model.fit(train_X, train_Y, epochs=100, batch_size=32, verbose=2)

train_predict = model.predict(train_X)
test_predict = model.predict(test_X)
# print('X\n\n\n', test_X, '\n\n\nY\n\n\n', test_predict)

train_predict = scaler.inverse_transform(train_predict)
train_Y = scaler.inverse_transform(train_Y)
test_predict = scaler.inverse_transform(test_predict)
test_Y = scaler.inverse_transform(test_Y)

train_rmse = np.sqrt(np.mean((train_predict - train_Y)**2))
test_rmse = np.sqrt(np.mean((test_predict - test_Y)**2))
print('Train RMSE: {:.2f}'.format(train_rmse))
print('Test RMSE: {:.2f}'.format(test_rmse))

test_X = test_X.reshape(-1)
test_Y = test_Y.reshape(-1)
test_predict = test_predict.reshape(-1)
test_days = []
for i in range(len(test_X)):
    test_days.append(i)
plt.plot(test_days, test_Y, 'r', test_days, test_predict, 'b')
plt.title('Testing Difference')
plt.xlabel('Dates')
plt.ylabel('Number of Incidents')
plt.show()
plt.savefig('test_graph.png')
plt.close()

train_X = train_X.reshape(-1)
train_Y = train_Y.reshape(-1)
train_predict = train_predict.reshape(-1)
train_days = []
for i in range(len(train_X)):
    train_days.append(i)
plt.plot(train_days, train_Y, 'r', train_days, train_predict, 'b')
plt.title('Training Difference')
plt.xlabel('Dates')
plt.ylabel('Number of Incidents')
plt.show()
plt.savefig('train_graph.png')
plt.close()

model.save('lstm_model.h5')


# Convert the problem into a binary classification problem
# train_Y_binary = np.where(train_Y > 0, 1, 0)
# test_Y_binary = np.where(test_Y > 0, 1, 0)
# train_predict_binary = np.where(train_predict > 0, 1, 0)
# test_predict_binary = np.where(test_predict > 0, 1, 0)

# # Calculate the classification metrics
# train_acc = accuracy_score(train_Y_binary, train_predict_binary)
# test_acc = accuracy_score(test_Y_binary, test_predict_binary)
# train_recall = recall_score(train_Y_binary, train_predict_binary)
# test_recall = recall_score(test_Y_binary, test_predict_binary)
# train_f1 = f1_score(train_Y_binary, train_predict_binary)
# test_f1 = f1_score(test_Y_binary, test_predict_binary)

# print('Train Accuracy: {:.2f}'.format(train_acc))
# print('Test Accuracy: {:.2f}'.format(test_acc))
# print('Train Recall: {:.2f}'.format(train_recall))
# print('Test Recall: {:.2f}'.format(test_recall))
# print('Train F1 Score: {:.2f}'.format(train_f1))
# print('Test F1 Score: {:.2f}'.format(test_f1))

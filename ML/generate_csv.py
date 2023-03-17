import csv
import random

records=2800
print("Making %d records\n" % records)

fieldnames=['data_id','vehicle_id','driving_vehicle_speed',
            'nearby_vehicle_speed', 'nearby_vehicle_distance', 
            'latitude', 'longitude', 'is_rash', 'datetime']
writer = csv.DictWriter(open("driving_data.csv", "w"), fieldnames=fieldnames)

day = 1
writer.writerow(dict(zip(fieldnames, fieldnames)))
for i in range(1, records + 1):
  writer.writerow(dict([
    ('data_id', i),
    ('vehicle_id', 1),
    ('driving_vehicle_speed', round(random.uniform(0, 80), 2)),
    ('nearby_vehicle_speed', round(random.uniform(0, 80), 2)),
    ('nearby_vehicle_distance', round(random.uniform(0, 2), 2)),
    ('latitude', round(random.uniform(12.88412222, 13.120366), 5)),
    ('longitude', round(random.uniform(80.12105556, 80.253852), 5)),
    ('datetime', '2023-02-' + str(day) + ' 20:40:00')]))
  if i % 100 == 0:
    day += 1
  

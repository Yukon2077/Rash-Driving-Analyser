import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/apis/api.dart';

import '../models/vehicle_model.dart';

class Vehicle extends StatelessWidget {
  VehicleModel vehicle;

  Vehicle({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
        elevation: 4,
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/vehicle', arguments: vehicle),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.all(4),
                child: Image.network('${Api.baseUrl}/uploads/${vehicle.vehicleImage}'),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Text(
                  vehicle.vehicleName,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                child: Text(
                  vehicle.vehicleNumber,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

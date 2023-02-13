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
                child: (vehicle.vehicleImage != 'None') ? FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg', image: '${Api.baseUrl}/uploads/${vehicle.vehicleImage}') : Image.asset('assets/placeholder.jpg'),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Text(
                  vehicle.vehicleName,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

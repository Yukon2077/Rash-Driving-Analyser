import 'package:flutter/material.dart';

import '../forms/add_vehicle_form.dart';

class AddVehicle extends StatelessWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
      ),
      body: Column(
        children: [AddVehicleForm()],
      ),
    );
  }
}

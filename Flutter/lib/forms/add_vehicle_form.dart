import 'package:flutter/material.dart';

class AddVehicleForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddVehicleFormState();
  }

}

class AddVehicleFormState extends State<AddVehicleForm> {

  final _addVehicleFormKey = GlobalKey<FormState>();
  var vehicleNameController = TextEditingController();
  var vehicleNumberController = TextEditingController();
  var vehicleImageController = TextEditingController();

  @override
  void dispose() {
    vehicleNameController.dispose();
    vehicleNumberController.dispose();
    vehicleImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addVehicleFormKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            child: TextFormField(
              controller: vehicleNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please give a name';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vehicle Name',
              ),
            ),
          ),
        ],
      ),
    );
  }

}
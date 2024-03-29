import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/api.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddVehicleFormState();
  }
}

class AddVehicleFormState extends State<AddVehicleForm> {
  final _addVehicleFormKey = GlobalKey<FormState>();
  var vehicleNameController = TextEditingController();
  var vehicleImageController = TextEditingController();
  File? _vehicleImage;
  Future<String>? addVehicleFuture;

  @override
  void dispose() {
    vehicleNameController.dispose();
    vehicleImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addVehicleFormKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            2 * AppBar().preferredSize.height,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: TextFormField(
                controller: vehicleNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please give a name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vehicle Name',
                ),
              ),
            ),
            const Text(
              'Pick a image for your vehicle (Optional)',
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      label: const Text('Gallery'),
                      icon: const Icon(Icons.browse_gallery),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(6, 12, 12, 12),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      label: const Text('Camera'),
                      icon: const Icon(Icons.camera),
                    ),
                  ),
                ),
              ],
            ),
            if (_vehicleImage != null)
              Container(
                margin: const EdgeInsets.all(12),
                child: Image.file(_vehicleImage!),
              ),
            const Spacer(),
            FutureBuilder(
                future: addVehicleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.active) {
                    return Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: const CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 48,
                            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_addVehicleFormKey.currentState!
                                        .validate()) {
                                      String vehicleName =
                                          vehicleNameController.text;
                                      addVehicleFuture = Api.addVehicle(
                                          vehicleName, _vehicleImage);
                                    }
                                  });
                                },
                                child: const Text('Add Vehicle')),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasData) {
                      String result = snapshot.data.toString();
                      Navigator.of(context).pop(result);
                    }
                  }
                  return Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_addVehicleFormKey.currentState!.validate()) {
                              String vehicleName = vehicleNameController.text;
                              addVehicleFuture =
                                  Api.addVehicle(vehicleName, _vehicleImage);
                            }
                          });
                        },
                        child: const Text('Add Vehicle')),
                  );
                }),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: imageSource);
    setState(() {
      _vehicleImage = File(image!.path);
    });
  }
}

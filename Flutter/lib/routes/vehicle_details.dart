import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/models/vehicle_model.dart';

import '../apis/api.dart';

class VehicleDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VehicleDetailState();
  }
}

class VehicleDetailState extends State<VehicleDetail> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)!.settings.arguments as VehicleModel;
    Image vehicleImage = Image.network('${Api.baseUrl}/uploads/${vehicle.vehicleImage}', fit: BoxFit.cover);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(vehicle.vehicleName),
                  background: vehicleImage,
                ),
              )
            ];
          },
          body: Center(
            child: Column(),
          )),
    );
  }

}

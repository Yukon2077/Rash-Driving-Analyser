import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/models/vehicle_model.dart';
import 'package:rash_driving_analyser/widgets/vehicle.dart';

import '../apis/api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late Future<List<VehicleModel>> vehicleFuture;

  @override
  void initState() {
    super.initState();
    vehicleFuture = Api.getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/vehicle/add'),
        child: const Icon(Icons.add),
      ),
      body: Center(
          child: (vehicleFuture == null)
              ? Container(
                  width: 48,
                  height: 48,
                  margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: CircularProgressIndicator())
              : FutureBuilder<List<VehicleModel>>(
                  future: vehicleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                          width: 48,
                          height: 48,
                          margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      var vehicles = snapshot.data;
                      if (vehicles == null) {
                        return const Text(
                          'None',
                          textAlign: TextAlign.center,
                        );
                      }
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            return Vehicle(
                              vehicle: vehicles[index],
                            );
                          });
                    }
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }

                    return Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Text('No Vehicles Added Yet'));
                  })),
    );
  }
}

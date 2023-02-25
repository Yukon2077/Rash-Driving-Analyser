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
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/vehicle/add'),
        child: const Icon(Icons.add),
      ),
      body: Center(
          child: FutureBuilder<List<VehicleModel>>(
              future: vehicleFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData || snapshot.hasError) {
                  List<VehicleModel> vehicles =
                      snapshot.hasData ? snapshot.data! : [];
                  return RefreshIndicator(
                      onRefresh: _refresh,
                      child: snapshot.hasError
                          ? Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                            )
                          : vehicles.isEmpty
                              ? const Text('No Vehicles Added Yet')
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 100),
                                  itemCount: vehicles.length,
                                  itemBuilder: (context, index) {
                                    return Vehicle(
                                      vehicle: vehicles[index],
                                    );
                                  }));
                }

                return const CircularProgressIndicator();
              })),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      vehicleFuture = Api.getVehicles();
    });
  }
}

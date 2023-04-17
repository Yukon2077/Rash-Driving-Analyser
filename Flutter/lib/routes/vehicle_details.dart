import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:rash_driving_analyser/models/vehicle_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_map/flutter_map.dart';

import '../apis/api.dart';

class VehicleDetail extends StatefulWidget {
  const VehicleDetail({super.key});

  @override
  State<StatefulWidget> createState() {
    return VehicleDetailState();
  }
}

class VehicleDetailState extends State<VehicleDetail> {
  Future<Object>? vehicleFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehicle = ModalRoute.of(context)!.settings.arguments as VehicleModel;
    vehicleFuture = Api.getVehicleData(vehicle.vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)!.settings.arguments as VehicleModel;
    Image vehicleImage = (vehicle.vehicleImage != 'None')
        ? Image.network('${Api.baseUrl}/uploads/${vehicle.vehicleImage}',
            fit: BoxFit.cover)
        : Image.asset('assets/placeholder.jpg', fit: BoxFit.cover);
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
              child: FutureBuilder(
            future: vehicleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                dynamic vehicleData = snapshot.data;
                var lastKnownLatitude = vehicleData['data'][0]['latitude'];
                var lastKnownLongitude = vehicleData['data'][0]['longitude'];

                var predictionForTomorrow =
                    vehicleData['prediction_for_tomorrow'].toString();

                final List<ChartData> chartData = [];

                for (int i = 0;
                    i < vehicleData['line_chart_data'].length;
                    i++) {
                  var data = vehicleData['line_chart_data'][i];
                  try {
                    var chartPoint =
                        ChartData(DateTime.parse(data['date']), data['count']);
                    chartData.add(chartPoint);
                  } catch (exception) {
                    debugPrint(exception.toString());
                  }
                }

                return ListView(children: [
                  Container(
                    height: 400,
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Card(
                      color: (int.parse(predictionForTomorrow) > 75)
                          ? Colors.red
                          : (int.parse(predictionForTomorrow) > 50)
                              ? Colors.yellow
                              : Colors.green,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Our prediction is that $predictionForTomorrow incidents may occur tomorrow.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const Text(
                                "Please remember that our prediction is not a guarantee and there are many factors that can influence the actual number of incidents.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 400,
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Card(
                      child: SfCartesianChart(
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
                          title:
                              ChartTitle(text: 'Number of incidents per day'),
                          primaryXAxis: DateTimeAxis(
                              title: AxisTitle(text: 'Days'),
                              intervalType: DateTimeIntervalType.days),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Incidents'),
                            desiredIntervals: 5,
                            rangePadding: ChartRangePadding.round,
                          ),
                          series: <ChartSeries>[
                            // Render pie chart
                            LineSeries<ChartData, DateTime>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings:
                                    const MarkerSettings(isVisible: true),
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true))
                          ]),
                    ),
                  ),
                  Container(
                    height: 400,
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Card(
                        child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(lastKnownLatitude, lastKnownLongitude),
                        zoom: 15,
                      ),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(
                          source: 'OpenStreetMap contributors',
                          onSourceTapped: null,
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point:
                                  LatLng(lastKnownLatitude, lastKnownLongitude),
                              anchorPos: AnchorPos.align(AnchorAlign.top),
                              builder: (context) => const Icon(
                                Icons.location_on,
                                size: 32,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                ]);
              }
              return const CircularProgressIndicator();
            },
          ))),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  final int y;
}

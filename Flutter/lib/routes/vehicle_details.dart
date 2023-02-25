import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/models/vehicle_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../apis/api.dart';

class VehicleDetail extends StatefulWidget {
  const VehicleDetail({super.key});

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
    final List<ChartData> chartData = [
      ChartData('Close Calls', 8),
      ChartData('Excessive Speeding', 4),
      ChartData('Hard Cornering', 3),
      ChartData('Quick Starts', 2),
      ChartData('Harsh Braking', 3)
    ];

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
            child: Column(children: [
              SfCircularChart(series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
            ]),
          )),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

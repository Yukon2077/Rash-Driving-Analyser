import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../widgets/vehicle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Chart(
              data: [
                {'day': '6/10', 'incidents': 21},
                {'day': '7/10', 'incidents': 15},
                {'day': '8/10', 'incidents': 12},
                {'day': 'Yesterday', 'incidents': 10},
                {'day': 'Today', 'incidents': 0},
              ],
              variables: {
                'day': Variable(
                  accessor: (Map map) => map['day'] as String,
                ),
                'incidents': Variable(
                  accessor: (Map map) => map['incidents'] as num,
                ),
              },
              elements: [IntervalElement()],
              axes: [
                Defaults.horizontalAxis,
                Defaults.verticalAxis,
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Vehicle(
              src:
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/2018_McLaren_720S_V8_S-A_4.0.jpg/1920px-2018_McLaren_720S_V8_S-A_4.0.jpg',
              name: 'McLaren 720S',
              number: 'C9 KAR',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/vehicle.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(children: [
        Vehicle(
          src:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/2018_McLaren_720S_V8_S-A_4.0.jpg/1920px-2018_McLaren_720S_V8_S-A_4.0.jpg',
          name: 'McLaren 720S',
          number: 'C9 KAR',
        )
      ]),
    );
  }
}

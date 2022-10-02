import 'package:flutter/material.dart';

import 'package:rash_driving_analyser/routes/home.dart';
import 'package:rash_driving_analyser/routes/login.dart';
import 'package:rash_driving_analyser/routes/profile.dart';
import 'package:rash_driving_analyser/routes/register.dart';
import 'package:rash_driving_analyser/routes/vehicle_details.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  final bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rash Driving Analyser',
      initialRoute: getInitialRoute(),
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/vehicle': (context) => VehicleDetail(),
        '/profile': (context) => Profile(),
      },
    );
  }

  String getInitialRoute() {
    if (isLogged) {
      return '/home';
    } else {
      return '/login';
    }

  }
}

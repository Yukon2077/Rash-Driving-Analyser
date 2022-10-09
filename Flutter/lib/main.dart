import 'package:flutter/material.dart';

import 'package:rash_driving_analyser/routes/home.dart';
import 'package:rash_driving_analyser/routes/login.dart';
import 'package:rash_driving_analyser/routes/profile.dart';
import 'package:rash_driving_analyser/routes/register.dart';
import 'package:rash_driving_analyser/routes/vehicle_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  token = await prefs.getString('token') ?? '';
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rash Driving Analyser',
      initialRoute: (token != '' || token.isNotEmpty) ? '/home' : '/login',
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/vehicle': (context) => VehicleDetail(),
        '/profile': (context) => Profile(),
      },
    );
  }
}

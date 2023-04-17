import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rash_driving_analyser/routes/testing.dart';
import 'package:rash_driving_analyser/routes/add_vehicle.dart';
import 'package:rash_driving_analyser/routes/home.dart';
import 'package:rash_driving_analyser/routes/login.dart';
import 'package:rash_driving_analyser/routes/profile.dart';
import 'package:rash_driving_analyser/routes/register.dart';
import 'package:rash_driving_analyser/routes/vehicle_details.dart';

String token = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token') ?? '';
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: 'Rash Driving Analyser',
      initialRoute:
          '/testing', //(token != '' || token.isNotEmpty) ? '/home' : '/login',
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/vehicle': (context) => const VehicleDetail(),
        '/vehicle/add': (context) => const AddVehicle(),
        '/profile': (context) => const Profile(),
        '/testing': (context) => Testing(),
      },
      theme: ThemeData(textTheme: GoogleFonts.firaSansTextTheme()),
    );
  }
}

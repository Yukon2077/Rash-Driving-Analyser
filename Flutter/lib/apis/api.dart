import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vehicle_model.dart';

class Api {
  static String? baseUrl;

  static Future<void> getIP() async {
    SharedPreferences.getInstance()
        .then((prefs) => baseUrl = prefs.getString('baseUrl'));
  }

  static Future<String> login(String email, String password) async {
    await getIP();
    var response = await http.post(
      Uri.parse('${baseUrl}api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response.body;
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  static Future<String> register(
      String name, String email, String password) async {
    await getIP();
    var response = await http.post(
      Uri.parse('${baseUrl}api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response.body;
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  static Future<List<VehicleModel>> getVehicles() async {
    await getIP();
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token == '') throw 'Token missing. Please login again';

    var response = await http.get(
      Uri.parse('${baseUrl}api/vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      var vehiclesJson = jsonDecode(response.body) as List;
      List<VehicleModel> vehicles =
          vehiclesJson.map((e) => VehicleModel.fromJson(e)).toList();
      return vehicles;
    } else {
      var body = jsonDecode(response.body);
      throw body['message'];
    }
  }

  static Future<Map<String, dynamic>> getVehicleData(int id) async {
    await getIP();
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token == '') throw 'Token missing. Please login again';

    var response = await http.get(
      Uri.parse('${baseUrl}api/vehicle/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      var vehicleDataJson = jsonDecode(response.body);
      return vehicleDataJson;
    } else {
      var body = jsonDecode(response.body);
      throw body['message'];
    }
  }

  static Future<String> addVehicle(
      String vehicleName, File? vehicleImage) async {
    await getIP();
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token == '') throw 'Token missing. Please login again';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}api/vehicle'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    request.fields['vehicle_name'] = vehicleName;
    if (vehicleImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'vehicle_image', vehicleImage.path));
    }
    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode >= 200 && response.statusCode < 400) {
      var vehicleDataJson = jsonDecode(response.body);
      return vehicleDataJson['message'];
    } else {
      var body = jsonDecode(response.body);
      throw body['message'];
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vehicle_model.dart';

class Api {

  static const String baseUrl = 'http://192.168.29.220/';

  static Future<String> login(String email, String password) async {
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
      throw jsonDecode(response.body).body['message'];
    }
  }

  static Future<String> register(String name, String email, String password) async {
    var response = await http.post(
      Uri.parse('${baseUrl}api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response.body;
    } else {
      throw jsonDecode(response.body).body['message'];
    }
  }

  static Future<List<VehicleModel>> getVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token == '') throw 'Token missing. Please login again';

    var response = await http.get(
      Uri.parse('${baseUrl}api/vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $token'
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      var vehiclesJson = jsonDecode(response.body) as List;
      List<VehicleModel> vehicles = vehiclesJson
          .map((e) => VehicleModel.fromJson(e))
          .toList();
      return vehicles;
    } else {
      var body = jsonDecode(response.body);
      throw body['message'];
    }
  }

  static Future<String> getVehicleData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token == '') throw 'Token missing. Please login again';

    var response = await http.get(
      Uri.parse('${baseUrl}api/vehicle/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $token'
      },
    );

  }

}
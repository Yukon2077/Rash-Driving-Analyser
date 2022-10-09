import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  static Future<String> getVehicles(String token) async {
    var response = await http.get(
      Uri.http(baseUrl, 'api/vehicle', { 'token': token }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response.body;
    } else {
      var body = jsonDecode(response.body);
      throw body['message'];
    }
  }

}
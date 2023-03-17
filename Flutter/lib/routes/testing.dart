import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing extends StatelessWidget {
  var ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            width: double.infinity,
            child: TextField(
              controller: ipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ip address',
                isDense: true,
                prefix: Text("http://"),
                suffix: Text('/'),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => addIpAddress(context),
                child: const Text('Add IP Address')),
          )
        ],
      ),
    );
  }

  void addIpAddress(BuildContext context) async {
    var ip = ipController.text;
    if (ip == "") {
      ip = 'http://192.168.81.46/';
    } else {
      ip = 'http://$ip/';
    }
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('baseUrl', ip));
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    Navigator.pushReplacementNamed(
        context, (token != '' || token.isNotEmpty) ? '/home' : '/login');
  }
}

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(12, 0, 12, 48),
            child: Text(
              'Rash Driving Analyser',
              style: TextStyle(fontSize: 56),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ElevatedButton(
                onPressed: () => login(context), child: Text('Login')),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: TextButton(
                onPressed: () => register(context),
                child: Text('Don\'t have an account? Click here to register')),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/home');
  }

  void register(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }
}

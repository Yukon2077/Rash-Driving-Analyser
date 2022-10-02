import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
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
            margin: EdgeInsets.all(12),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ElevatedButton(
                onPressed: () => register(context), child: Text('Register')),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: TextButton(
                onPressed: () => login(context),
                child: Text('Already have an account? Click here to login')),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context) {
    Navigator.pop(context);
  }

  void register(BuildContext context) {
    Navigator.pop(context);
  }
}

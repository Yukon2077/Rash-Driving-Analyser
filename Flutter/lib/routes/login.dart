import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/forms/login_form.dart';

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
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 48),
            child: const Text(
              'Rash Driving Analyser',
              style: TextStyle(fontSize: 56),
              textAlign: TextAlign.center,
            ),
          ),
          const LoginForm(),
          TextButton(
              child: const Text('Don\'t have an account? Click here to register'),
              onPressed: () => register(context)),
        ],
      ),
    );
  }

  void register(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }
}

import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/forms/register_form.dart';

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
            margin: const EdgeInsets.all(12),
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ),
          const RegisterForm(),
          TextButton(
              onPressed: () => login(context),
              child:
                  const Text('Already have an account? Click here to login')),
        ],
      ),
    );
  }

  void login(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}

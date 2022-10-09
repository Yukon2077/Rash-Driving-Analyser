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
            margin: EdgeInsets.all(12),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ),
          RegisterForm(),
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
    Navigator.pushReplacementNamed(context, '/login');
  }

}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<String>? loginFuture;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  /*else if (!value.contains("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$")) {
                    return 'Please enter a valid email';
                  }*/
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return 'Password needs to be at least 8 characters';
                  }
                  /*else if (!value.contains('^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}\$')) {
                    return 'Password must contain a-z, A-Z and 0-9 characters at least once';
                  }*/
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            (loginFuture == null)
                ? Container(
              width: double.infinity,
              height: 48,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_loginFormKey.currentState!.validate()) {
                        String email = emailController.text;
                        String password = passwordController.text;
                        loginFuture = Api.login(email, password);
                      }
                    });
                  },
                  child: const Text('Login')),
            )
                : FutureBuilder(
                    future: loginFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.active) {
                        return Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: const CircularProgressIndicator());
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 48,
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_loginFormKey.currentState!
                                            .validate()) {
                                          String email = emailController.text;
                                          String password =
                                              passwordController.text;
                                          loginFuture =
                                              Api.login(email, password);
                                        }
                                      });
                                    },
                                    child: const Text('Login')),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasData) {
                          var body = jsonDecode(snapshot.data.toString());
                          SharedPreferences.getInstance().then((prefs) =>
                              prefs.setString('token', body['token']));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (route) => false);
                        }
                      }
                      return Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_loginFormKey.currentState!.validate()) {
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  loginFuture = Api.login(email, password);
                                }
                              });
                            },
                            child: const Text('Login')),
                      );
                    }),
          ],
        ));
  }
}

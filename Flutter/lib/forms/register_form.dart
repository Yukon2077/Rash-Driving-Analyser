import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Future<String>? registerFuture;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _registerFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
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
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: TextFormField(
                controller: confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords don\'t match';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            (registerFuture == null)
                ? Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_registerFormKey.currentState!.validate()) {
                              String name = nameController.text;
                              String email = emailController.text;
                              String password = passwordController.text;
                              registerFuture =
                                  Api.register(name, email, password);
                            }
                          });
                        },
                        child: const Text('Register')),
                  )
                : FutureBuilder(
                    future: registerFuture,
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
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 48,
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_registerFormKey.currentState!
                                            .validate()) {
                                          String name = nameController.text;
                                          String email = emailController.text;
                                          String password =
                                              passwordController.text;
                                          registerFuture = Api.register(
                                              name, email, password);
                                        }
                                      });
                                    },
                                    child: const Text('Register')),
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
                                if (_registerFormKey.currentState!.validate()) {
                                  String name = nameController.text;
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  registerFuture =
                                      Api.register(name, email, password);
                                }
                              });
                            },
                            child: const Text('Register')),
                      );
                    }),
          ],
        ));
  }
}

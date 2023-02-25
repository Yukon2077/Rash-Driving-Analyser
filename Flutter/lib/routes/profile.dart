import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SettingsList(sections: [
          SettingsSection(title: const Text('Profile'), tiles: [
            SettingsTile(
              title: const Text('Logout'),
              onPressed: (context) => logout(context),
            )
          ])
        ]));
  }

  void logout(BuildContext context) {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', ''));
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}

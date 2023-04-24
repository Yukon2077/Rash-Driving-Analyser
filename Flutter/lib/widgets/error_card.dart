import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String errorText;

  final IconData icon;

  const ErrorCard({Key? key, required this.errorText, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(24), child: Icon(icon, size: 48)),
            Text(errorText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

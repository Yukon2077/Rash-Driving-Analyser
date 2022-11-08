import 'package:flutter/material.dart';

class FormTextButton extends StatelessWidget {

  var onPressed;
  var text;

  FormTextButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: TextButton(
          onPressed: () => onPressed,
          child: Text(text)),
    );
  }

}
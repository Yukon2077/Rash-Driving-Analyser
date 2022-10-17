import 'package:flutter/material.dart';
import 'package:rash_driving_analyser/apis/api.dart';

class Vehicle extends StatelessWidget {
  String src;
  String name;
  String number;

  Vehicle(
      {Key? key, required this.src, required this.name, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 12,
        shadowColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(4),
              child: Image.network('${Api.baseUrl}/uploads/$src'),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Text(name, style: TextStyle(fontSize: 18),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Text(number, style: TextStyle(fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }
}

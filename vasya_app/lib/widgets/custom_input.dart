import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';

class CustomInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "HINT",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 18.0,
          )
        ),
        style: Constants.regularDartText,
      ),
    );
  }
}

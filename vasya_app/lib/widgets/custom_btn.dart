import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;

  CustomBtn({this.text, this.onPressed, this.outlineBtn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: outlineBtn ?? false ? Colors.transparent : Colors.black,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          text ?? 'Text',
          style: TextStyle(
            fontSize: 16.0,
            color: outlineBtn ?? false ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Homepage",
          style: Constants.regularHeading,
        ),
      ),
    );
  }
}

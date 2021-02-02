import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;

  CustomActionBar({this.title, this.hasBackArrow});

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0),
          ],
          begin: Alignment(0, 0),
          end: Alignment(0, 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: 45,
        left: 24,
        right: 24,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image(
                  color: Colors.white,
                  height: 16,
                  width: 16,
                  image: AssetImage(
                    "assets/images/back_arrow.png",
                  ),
                ),
              ),
            ),
          if (title != null)
            Text(
              title,
              style: Constants.boldHeading,
            ),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "0",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;
  final bool isLoading;

  CustomBtn({this.text, this.onPressed, this.outlineBtn, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: outlineBtn ?? false ? Colors.transparent : Theme.of(context).accentColor,
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading ?? false ? false : true,
              child: Center(
                child: Text(
                  text ?? 'Text',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: outlineBtn ?? false ? Theme.of(context).accentColor : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading ?? false ? true : false,
              child: Center(
                child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        outlineBtn ?? false ? Theme.of(context).accentColor : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

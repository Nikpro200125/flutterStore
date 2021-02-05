import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasBackground;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String user = FirebaseAuth.instance.currentUser.uid;
  CustomActionBar({this.title, this.hasBackArrow, this.hasBackground});

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasBackground = hasBackground ?? true;
    return Container(
      decoration: BoxDecoration(
        color: _hasBackground ? Colors.white : Colors.transparent,
      ),
      padding: EdgeInsets.only(
        top: 35,
        left: 24,
        right: 24,
        bottom: 10,
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
              child: StreamBuilder(
                stream: users.doc(user).collection('cart').snapshots(),
                builder: (context, snapshot) {
                  int total = 0;
                  if(snapshot.connectionState == ConnectionState
                  .active)
                    total = snapshot.data.docs.length;
                  return Text(
                    total.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

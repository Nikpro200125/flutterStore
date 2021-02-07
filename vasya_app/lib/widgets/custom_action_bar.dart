import 'package:flutter/material.dart';
import 'package:vasya_app/firebase_service.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasBackground;
  final FirebaseService firebaseService = FirebaseService();

  CustomActionBar({this.title, this.hasBackArrow, this.hasBackground});

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasBackground = hasBackground ?? true;
    return Container(
      decoration: BoxDecoration(
        color: _hasBackground ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2.0,
            blurRadius: 4.0,
          ),
        ],
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
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pop(context);
              },
              child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
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
          Text(
            title ?? 'Title',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          GestureDetector(
            // onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => CartTab()));
            // },
            child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: StreamBuilder(
                  stream: firebaseService.usersRef
                      .doc(FirebaseService().firebaseUser)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    int total = 0;
                    if (snapshot.connectionState == ConnectionState.active)
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
          ),
        ],
      ),
    );
  }
}

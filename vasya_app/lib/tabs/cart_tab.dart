import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class CartTab extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var myProducts = firebaseService.usersRef
        .doc(FirebaseService().firebaseUser)
        .collection('cart');
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: myProducts.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error ${snapshot.error}'),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(
                    top: 90,
                    bottom: 12,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFF4EADE),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "${document.data()['logo']}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 230,
                                margin: EdgeInsets.only(
                                  top: 20,
                                  left: 10,
                                ),
                                child: Text(
                                  "${document.data()['product']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: 230,
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                child: Text(
                                  "${document.data()['supplier']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: 230,
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                child: Text(
                                  "Итого: ${document.data()['quantity']} × ${document.data()['price']}" +
                                      Constants.currencySign,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            title: "Корзина",
          ),
        ],
      ),
    );
  }
}

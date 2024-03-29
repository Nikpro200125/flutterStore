import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/landing.dart';
import 'package:store/widgets/action_bar.dart';
import 'package:store/widgets/add_to_card_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class ProductPage extends StatefulWidget {
  final String documentIdProduct;

  ProductPage({this.documentIdProduct});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: firebaseService.productsRef.doc(widget.documentIdProduct).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        Center(
                          child: Text(
                            "Ошибка ${snapshot.error}",
                          ),
                        ),
                        CustomActionBar(
                          hasBackArrow: true,
                          title: 'Ошибка',
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.data.exists)
                    return Scaffold(
                      body: Stack(
                        children: [
                          Center(
                            child: Text(
                              "К сожалению, товара больше нет",
                            ),
                          ),
                          CustomActionBar(
                            hasBackArrow: true,
                            title: 'Товар не найден...',
                          ),
                        ],
                      ),
                    );
                  return Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.only(
                          bottom: 70,
                        ),
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 78,
                                    ),
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                          "${snapshot.data.data()['logo']}",
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Icon(
                                              Icons.warning,
                                              size: 60,
                                              color: Colors.red,
                                            );
                                          },
                                        ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        bottom: 12,
                                        right: 12,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 8,
                                      ),
                                      child: Center(
                                        child: Text(
                                          snapshot.data
                                                  .data()['price']
                                                  .toString() +
                                              Constants.currencySign,
                                          style: Constants.regularHeading,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.8),
                                            spreadRadius: 3.0,
                                            blurRadius: 8.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    bottom: 0,
                                    right: 0,
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 16,
                                        top: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Описание",
                                          style: Constants.regularHeading,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                          "${snapshot.data.data()['description']}"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CustomActionBar(
                        hasBackArrow: true,
                        title: snapshot.data.data()['name'],
                      ),
                      if (!FirebaseAuth.instance.currentUser.isAnonymous)
                        Positioned(
                          bottom: 0,
                          child: AddToCard(
                            supplier: snapshot.data.data()['supplier'],
                            documentIdProduct: widget.documentIdProduct,
                            image: snapshot.data.data()['logo'],
                            price: snapshot.data.data()['price'],
                            product: snapshot.data.data()['name'],
                          ),
                        )
                      else
                        Positioned(
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              color: Color(0xFFF4EADE),
                            ),
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    'Чтобы добавить в корзину - войдите',
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                CustomBtn(
                                  text: 'Войти',
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LandingPage(),
                                        ),
                                        (route) => false);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Scaffold(
                  body: Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      CustomActionBar(
                        hasBackArrow: true,
                        title: 'Загрузка...',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

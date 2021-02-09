import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_add_to_card_bar.dart';

class ProductPage extends StatelessWidget {
  final String documentIdProduct;
  final FirebaseService firebaseService = FirebaseService();

  ProductPage({this.documentIdProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: firebaseService.productsRef.doc(documentIdProduct).get(),
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
                  else
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
                                        '${snapshot.data.data()['logo']}',
                                        fit: BoxFit.fill,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                        Positioned(
                          bottom: 0,
                          child: AddToCard(
                            supplier: snapshot.data.data()['supplier'],
                            documentIdProduct: documentIdProduct,
                            image: snapshot.data.data()['logo'],
                            price: snapshot.data.data()['price'],
                            product: snapshot.data.data()['name'],
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

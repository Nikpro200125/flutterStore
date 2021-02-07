import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_add_to_card_bar.dart';

class ProductPage extends StatelessWidget {
  final String product;
  final String supplier;
  final String documentIdProduct;
  final String documentIdSupplier;
  final String documentIdCategory;
  final String productLogo;
  final int productPrice;
  final FirebaseService firebaseService = FirebaseService();

  ProductPage(
      {this.documentIdProduct,
      this.documentIdSupplier,
      this.documentIdCategory,
      this.product,
      this.productLogo,
      this.productPrice,
      this.supplier});

  @override
  Widget build(BuildContext context) {
    DocumentReference doc = firebaseService.categoriesRef
        .doc(documentIdCategory)
        .collection('suppliers')
        .doc(documentIdSupplier)
        .collection('products')
        .doc(documentIdProduct);

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder(
              future: doc.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        "Error ${snapshot.error}",
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
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
                                  top: 63,
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
                                  child: Center(
                                    child: Text(
                                      snapshot.data.data()['price'].toString() +
                                          Constants.currencySign,
                                      style: Constants.regularHeading,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).accentColor.withOpacity(0.5),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  width: 100,
                                  height: 40,
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
              hasBackArrow: true,
              title: product,
            ),
            Positioned(
              bottom: 0,
              child: AddToCard(
                supplier: supplier,
                documentIdProduct: documentIdProduct,
                image: productLogo,
                price: productPrice,
                product: product,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

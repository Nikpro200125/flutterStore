import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/product_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class SupplierPage extends StatelessWidget {
  final String supplier;
  final String documentIdSupplier;
  final String documentIdCategory;
  final FirebaseService firebaseService = FirebaseService();

  SupplierPage(
      {this.supplier, this.documentIdSupplier, this.documentIdCategory});

  @override
  Widget build(BuildContext context) {
    DocumentReference doc = firebaseService.categoriesRef
        .doc(documentIdCategory)
        .collection('suppliers')
        .doc(documentIdSupplier);

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: doc.collection('products').get(),
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
                  children: [
                    FutureBuilder(
                      future: doc.get(),
                      builder: (context, snapshot2) {
                        if (snapshot2.connectionState == ConnectionState.done) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 63,
                                ),
                                height: 300,
                                child: Image.network(
                                  '${snapshot2.data.data()['logo']}',
                                  fit: BoxFit.fill,
                                ),
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
                                          "${snapshot2.data.data()['description']}"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Center(
                        child: Text(
                          'Товары поставщика',
                          style: Constants.regularHeading,
                        ),
                      ),
                    ),
                    if (snapshot.data.size == 0)
                      Center(
                        child: Text(
                          'У этого поставщика пока нет товаров...',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Column(
                      children: snapshot.data.docs.map(
                        (document) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    product: document.data()['name'],
                                    documentIdProduct: document.id,
                                    documentIdCategory: documentIdCategory,
                                    documentIdSupplier: documentIdSupplier,
                                    productLogo: document.data()['logo'],
                                    productPrice: document.data()['price'],
                                    supplier: supplier,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
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
                                    margin: EdgeInsets.only(
                                      right: 12,
                                      left: 24,
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
                                  Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: 25,
                                          ),
                                          child: Text(
                                            "${document.data()['name']}",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Color(0xFF2988BC),
                                            ),
                                          ),
                                          width: 200,
                                        ),
                                        Positioned(
                                          top: 55,
                                          child: Container(
                                            child: Text(
                                              "${document.data()['price']}" +
                                                  Constants.currencySign,
                                              style: TextStyle(
                                                color: Color(0xFFED8C72),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
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
            title: supplier,
          ),
        ],
      ),
    );
  }
}

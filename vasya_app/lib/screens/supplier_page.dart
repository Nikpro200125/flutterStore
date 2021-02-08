import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/product_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class SupplierPage extends StatelessWidget {
  final String supplierId;
  final String category;
  final FirebaseService firebaseService = FirebaseService();

  SupplierPage({this.supplierId, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebaseService.suppliersRef.doc(supplierId).get(),
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
                    title: category,
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 55,
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        '${snapshot.data.data()['logo']}',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
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
                            child:
                                Text("${snapshot.data.data()['description']}"),
                          ),
                        ],
                      ),
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
                    FutureBuilder<QuerySnapshot>(
                      future: firebaseService.productsRef
                          .where('category', isEqualTo: category)
                          .where('supplier',
                              isEqualTo: snapshot.data.data()['name'])
                          .get(),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasError)
                          return Center(
                            child: Text(
                              "Ошибка ${snapshot.error}",
                            ),
                          );
                        if (snapshot2.connectionState == ConnectionState.done)
                          return Column(
                            children: snapshot2.data.docs.map(
                              (document) {
                                if (snapshot2.data.size == 0)
                                  return Center(
                                    child: Text(
                                      'У этого поставщика пока нет товаров...',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                          documentIdProduct: document.id,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                          );
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
                CustomActionBar(
                  hasBackArrow: true,
                  title: snapshot.data.data()['name'],
                ),
              ],
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                CircularProgressIndicator(),
                CustomActionBar(
                  hasBackArrow: true,
                  title: category,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/supplier_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final FirebaseService firebaseService = FirebaseService();

  CategoryPage({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: firebaseService.suppliersRef
                .where('categories', arrayContains: category)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Stack(
                    children: [
                      Center(
                        child: Text('Ошибка ${snapshot.error}'),
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
                if (snapshot.data.size == 0) {
                  return Center(
                    child: Text("Нет таких поставщиков..."),
                  );
                }
                return ListView(
                      padding: EdgeInsets.only(
                        top: 90,
                        bottom: 12,
                      ),
                      children: snapshot.data.docs.map(
                            (document) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SupplierPage(
                                        category: category,
                                        supplierId: document.id,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 108,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ColorFiltered(
                                        child: Image.network(
                                          "${document.data()['logo']}",
                                          fit: BoxFit.fitWidth,
                                        ),
                                        colorFilter: ColorFilter.mode(
                                          Colors.black54,
                                          BlendMode.darken,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 22,
                                          bottom: 10,
                                          left: 12,
                                          right: 12,
                                        ),
                                        child: Center(
                                          child: Container(
                                            child: Text(
                                              "${document.data()['name']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Средняя цена:  ${document
                                                .data()['averageprice']}" +
                                                Constants.currencySign,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            title: category,
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/screens/supplier_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final String documentIdCategory;
  final CollectionReference products =
      FirebaseFirestore.instance.collection('categories');

  CategoryPage({this.category, this.documentIdCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: products
                  .doc(documentIdCategory)
                  .collection('suppliers')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error ${snapshot.error}'),
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
                    children: snapshot.data.docs.map((document) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupplierPage(
                                documentIdCategory: documentIdCategory,
                                documentIdSupplier: document.id,
                                supplier: document.data()['name'],
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
                                width: double.infinity,
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
                                        "Средняя цена:  ${document.data()['averageprice']}",
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
              title: category,
              hasBackArrow: true,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final String documentId;

  CategoryPage({this.category, this.documentId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference products = FirebaseFirestore.instance
        .collection('categories')
        .doc(documentId)
        .collection('products');
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: products.get(),
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
                      child: Text("Нет таких товаров..."),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 90,
                      bottom: 90,
                    ),
                    children: snapshot.data.docs.map((document) {
                      return Container(
                        height: 150,
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
                                child: Image.network(
                                  "${document.data()['logo']}",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  bottom: 5,
                                ),
                                child: Container(
                                  child: Text(
                                    "${document.data()['name']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                              bottom: 0,
                              left: 0,
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
              title: "Товары",
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      spreadRadius: 1.0,
                      blurRadius: 30.0,
                    ),
                  ],
                ),
                child: CustomBtn(
                  text: 'Все категории',
                  outlineBtn: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

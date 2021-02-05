import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/screens/category_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: categories.get(),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              category: document.data()['name'],
                              documentIdCategory: document.id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
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
                            Container(
                              child: Center(
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
            title: "Главная",
          ),
        ],
      ),
    );
  }
}

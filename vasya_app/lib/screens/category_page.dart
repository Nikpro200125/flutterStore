import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/supplier_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  CategoryPage({this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: firebaseService.suppliersRef
                .where('categories', arrayContains: widget.category)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Ошибка ${snapshot.error}'),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.size == 0) {
                  return Center(
                    child: Text("Нет таких поставщиков..."),
                  );
                } else
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
                                builder: (context) => SupplierPage(
                                  category: widget.category,
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
                                  width: MediaQuery.of(context).size.width,
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
                                          "Средняя цена:  ${document.data()['averageprice']}" +
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
                                if (FirebaseAuth
                                        .instance.currentUser.phoneNumber ==
                                    Constants.adminPhone)
                                  GestureDetector(
                                    onTap: () {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Подтвердить удаление',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'Удалить',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  firebaseService.suppliersRef
                                                      .doc(document.id)
                                                      .delete();
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Отмена',
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 8,
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      alignment: Alignment.topRight,
                                    ),
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
            title: widget.category,
          ),
        ],
      ),
    );
  }
}

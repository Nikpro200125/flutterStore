import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/product_page.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class SupplierPage extends StatefulWidget {
  final String supplierId;
  final String category;

  SupplierPage({this.supplierId, this.category});

  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebaseService.suppliersRef.doc(widget.supplierId).get(),
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
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 50,
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
                          .where('category', isEqualTo: widget.category)
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
                          else
                          return Column(
                            children: snapshot2.data.docs.map(
                              (document) {
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 24,
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
                                          margin: EdgeInsets.only(
                                            top: 24,
                                            left: 148,
                                          ),
                                          height: 100,
                                          child: Stack(
                                            children: [
                                              Container(
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
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 60,
                                                ),
                                                child: Text(
                                                  "${document.data()['price']}" +
                                                      Constants.currencySign,
                                                  style: TextStyle(
                                                    color: Color(0xFFED8C72),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (FirebaseAuth.instance.currentUser.phoneNumber ==
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
                                                          firebaseService.productsRef
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
                  title: 'Загрузка...',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

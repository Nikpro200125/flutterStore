import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store/admin_tabs/edit_supplier.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/supplier_page.dart';
import 'package:store/widgets/custom_action_bar.dart';

class CategoryPage extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();
  final String category;

  CategoryPage({this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: widget.firebaseService.suppliersRef.where('categories', arrayContains: widget.category).get(),
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
                          onLongPress: () {
                            if (FirebaseAuth.instance.currentUser.phoneNumber == Constants.adminPhone) load(document.id);
                          },
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
                                          "Средняя цена:  ${document.data()['averageprice']}" + Constants.currencySign,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (FirebaseAuth.instance.currentUser.phoneNumber == Constants.adminPhone)
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
                                                FirebaseStorage.instance.refFromURL(document.data()['logo']).delete();
                                                setState(() {
                                                  widget.firebaseService.suppliersRef.doc(document.id).delete();
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Отмена',
                                              ),
                                              onPressed: () => Navigator.pop(context),
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

  void load(String docId) {
    widget.firebaseService.categoriesRef.get().then(
          (value) => widget.firebaseService.suppliersRef.doc(docId).get().then(
            (value2) {
              Map<String, bool> l = Map.fromIterable(value.docs.map((e) => e.data()['name']).toList(), value: (value) => false);
              List<String> current = List.castFrom(value2.data()['categories']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSupplier(l.map((key, value) => MapEntry(key, current.contains(key))), docId, value2),
                ),
              );
            },
          ),
        );
  }
}

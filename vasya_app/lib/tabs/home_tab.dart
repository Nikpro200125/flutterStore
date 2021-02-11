import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/category_page.dart';
import 'package:vasya_app/screens/edit_category.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: firebaseService.categoriesRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Ошибка ${snapshot.error}'),
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
                      onLongPress: () {
                        if (FirebaseAuth.instance.currentUser.phoneNumber ==
                            Constants.adminPhone)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditCategory(docId: document.id),
                            ),
                          );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              category: document.data()['name'],
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
                                              firebaseService.categoriesRef
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
            title: "Категории",
          ),
        ],
      ),
    );
  }
}

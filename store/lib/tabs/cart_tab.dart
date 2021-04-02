import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/landing.dart';
import 'package:store/screens/product_page.dart';
import 'package:store/screens/send_order.dart';
import 'package:store/widgets/custom_action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (!FirebaseAuth.instance.currentUser.isAnonymous)
            FutureBuilder<QuerySnapshot>(
              future: firebaseService.usersRef
                  .doc(FirebaseService().firebaseUser)
                  .collection('cart')
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
                  if (snapshot.data.size == 0)
                    return Center(
                      child: Text(
                        'Тут пусто...',
                        textAlign: TextAlign.center,
                      ),
                    );
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 90,
                      bottom: 70,
                    ),
                    children: [
                      Column(
                        children: snapshot.data.docs.map(
                          (document) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    documentIdProduct: document.id,
                                  ),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFFF4EADE),
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          "${document.data()['logo']}",
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Icon(
                                              Icons.warning,
                                              size: 60,
                                              color: Colors.red,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Text(
                                            "${document.data()['product']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            "${document.data()['supplier']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            "Итого: ${document.data()['quantity']} × ${document.data()['price']}" +
                                                Constants.currencySign,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                                    firebaseService.usersRef
                                                        .doc(firebaseService.firebaseUser)
                                                        .collection('cart')
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
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Чтобы пользоваться корзиной необходимо войти',
                  textAlign: TextAlign.center,
                ),
                CustomBtn(
                  text: 'Войти',
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandingPage(),
                        ),
                        (route) => false);
                  },
                ),
              ],
            ),
          if (!FirebaseAuth.instance.currentUser.isAnonymous)
            FutureBuilder<QuerySnapshot>(
              future: firebaseService.usersRef
                  .doc(firebaseService.firebaseUser)
                  .collection('cart')
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
                  if (snapshot.data.size != 0)
                    return Positioned(
                      bottom: 10,
                      left: 4,
                      right: 4,
                      child: CustomBtn(
                        text: 'Отправить заявку',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendOrder(),
                          ),
                        ),
                      ),
                    );
                  return Container();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          CustomActionBar(
            title: "Корзина",
          ),
        ],
      ),
    );
  }
}

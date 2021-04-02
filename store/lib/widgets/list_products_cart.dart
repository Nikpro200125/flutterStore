import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/product_page.dart';

class ListProductsCard extends StatefulWidget {
  final List<QueryDocumentSnapshot> products;

  ListProductsCard({this.products});

  @override
  _ListProductsCardState createState() => _ListProductsCardState();
}

class _ListProductsCardState extends State<ListProductsCard> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.products.map(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          "Итого: ${document.data()['quantity']} × ${document.data()['price']}" + Constants.currencySign,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Theme.of(context).accentColor,
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
                              onPressed: () => setState(
                                    () {
                                  firebaseService.usersRef.doc(firebaseService.firebaseUser).collection('cart').doc(document.id).delete();
                                  Navigator.pop(context);
                                },
                              ),
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
}

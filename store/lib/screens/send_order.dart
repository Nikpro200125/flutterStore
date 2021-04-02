import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/product_page.dart';
import 'package:store/widgets/custom_action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class SendOrder extends StatefulWidget {
  @override
  _SendOrderState createState() => _SendOrderState();
}

class _SendOrderState extends State<SendOrder> {
  final FirebaseService firebaseService = FirebaseService();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var deleted = [];
  bool isLoading = false;
  bool showDeleted = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'ФИО',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Введите ФИО';
                      }
                      return null;
                    },
                    maxLength: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CustomBtn(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        deleted = [];
                        List<String> prod = await firebaseService.productsRef.get().then((value) => value.docs.toList().map((e) => e.id).toList());
                        QuerySnapshot cart = await firebaseService.usersRef.doc(firebaseService.firebaseUser).collection('cart').get();
                        cart.docs.forEach((element) async {
                          if (!prod.contains(element.id)) deleted.add(element);
                        });
                        if (deleted.isNotEmpty) {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Некоторые товары больше недоступны для заказа, продолжить без них?',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Да',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                                TextButton(
                                  child: Text(
                                    'Отмена',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showDeleted = true;
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      text: 'Сохранить',
                      isLoading: isLoading,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      "Следующие товары больше недоступны!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: deleted.map(
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
                  ),
                ],
              ),
            ),
          ),
          CustomActionBar(
            title: "Оформление заявки",
            hasBackArrow: true,
          ),
        ],
      ),
    );
  }

  Future<void> order() async {}
}

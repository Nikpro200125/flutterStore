import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class AddToCard extends StatefulWidget {
  final String documentIdProduct;
  final String documentIdSupplier;
  final String image;
  final int price;

  AddToCard(
      {this.documentIdProduct,
      this.documentIdSupplier,
      this.image,
      this.price});

  @override
  _AddToCardState createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {
  int counter = 0;
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = "0";
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final SnackBar snackBar =
      SnackBar(content: Text('Продукт добавлен в корзину!'));
  final SnackBar snackBarError =
      SnackBar(content: Text('Нужно выбрать хотя бы один товар...'));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Color(0xFFF4EADE),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomBtn(
            text: 'Добавить в корзину',
            outlineBtn: true,
            onPressed: () async {
              if (counter != 0) {
                await users
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('cart')
                    .doc(widget.documentIdProduct)
                    .set(
                  {
                    'supplier': widget.documentIdSupplier,
                    'product': widget.documentIdProduct,
                    'quantity': counter,
                    'logo': widget.image,
                    'price': widget.price,
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else
                ScaffoldMessenger.of(context).showSnackBar(snackBarError);
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (counter != 0) counter--;
                controller.text = counter.toString();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7,
              ),
              child: Image(
                image: AssetImage('assets/images/minus.png'),
                color: Theme.of(context).accentColor,
                width: 25,
              ),
            ),
          ),
          Container(
            width: 44,
            child: TextField(
              onChanged: (value) => setState(() {
                if (value.isNotEmpty)
                  counter = int.parse(value);
                else {
                  counter = 0;
                  controller.text = '0';
                }
              }),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                counter++;
                controller.text = counter.toString();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7,
              ),
              child: Image(
                image: AssetImage('assets/images/plus.png'),
                color: Theme.of(context).accentColor,
                width: 25,
              ),
            ),
          ),
          Text(
            'шт. ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

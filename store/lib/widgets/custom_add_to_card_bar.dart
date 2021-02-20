import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/firebase_service.dart';
import 'package:store/widgets/custom_btn.dart';

class AddToCard extends StatefulWidget {
  final String documentIdProduct;
  final String supplier;
  final String image;
  final double price;
  final String product;

  AddToCard({this.documentIdProduct, this.image, this.price, this.supplier, this.product});

  @override
  _AddToCardState createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {
  final FirebaseService firebaseService = FirebaseService();
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomBtn(
            text: 'Добавить в корзину',
            outlineBtn: true,
            onPressed: () {
              if (counter != 0) {
                firebaseService.usersRef.doc(firebaseService.firebaseUser).collection('cart').doc(widget.documentIdProduct).set(
                  {
                    'supplier': widget.supplier,
                    'quantity': counter,
                    'logo': widget.image,
                    'price': widget.price,
                    'product': widget.product,
                  },
                ).whenComplete(
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Продукт добавлен в корзину!'),
                      ),
                    );
                  },
                );
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Нужно выбрать хотя бы один товар...'),
                  ),
                );
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
              onChanged: (value) => setState(
                () {
                  if (value.isNotEmpty) counter = int.parse(value);
                },
              ),
              onSubmitted: (value) => setState(() {
                if (value.isNotEmpty)
                  counter = int.parse(value);
                else {
                  counter = 0;
                  controller.text = "0";
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
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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

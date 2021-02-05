import 'package:flutter/material.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class AddToCard extends StatefulWidget {
  @override
  _AddToCardState createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Color(0xFFF4EADE),
      ),
      child: Row(
        children: [
          CustomBtn(
            text: 'Добавить в корзину',
            outlineBtn: true,
          ),
        ],
      ),
    );
  }
}

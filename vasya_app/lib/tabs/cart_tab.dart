import 'package:flutter/material.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class CartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text(
              "Cart",
            ),
          ),
          CustomActionBar(
            title: "Корзина",
          ),
        ],
      ),
    );
  }
}

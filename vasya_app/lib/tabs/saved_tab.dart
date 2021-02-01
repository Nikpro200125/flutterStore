import 'package:flutter/material.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text(
              "Home Tab",
            ),
          ),
          CustomActionBar(
            title: "Сохраненные",
          ),
        ],
      ),
    );
  }
}

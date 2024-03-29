import 'package:flutter/material.dart';
import 'package:store/constants.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final isPassword;
  final onTap;

  CustomInput(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPassword,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        onTap: onTap,
        obscureText: isPassword ?? false,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: hintText ?? 'Hint text',
          border: InputBorder.none,
          hintText: hintText ?? 'Hint text',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 18.0,
          ),
        ),
        style: Constants.regularDarkText,
      ),
    );
  }
}

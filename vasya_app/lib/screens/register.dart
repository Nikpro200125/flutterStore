import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/screens/auth.dart';
import 'package:vasya_app/widgets/custom_btn.dart';
import 'package:vasya_app/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 26),
                  child: Text(
                    'Добро пожаловать,\nсоздайте аккаунт',
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(hintText: 'Email...',),
                    CustomInput(hintText: 'Password...',),
                    CustomBtn(
                      text: 'Создать',
                      outlineBtn: false,
                      onPressed: (){
                        print('Clicked login btn');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: CustomBtn(
                    text: 'Уже есть! Войти',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

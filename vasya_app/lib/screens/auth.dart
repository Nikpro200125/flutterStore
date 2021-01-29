import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/screens/register.dart';
import 'package:vasya_app/services/auth.dart';
import 'package:vasya_app/widgets/custom_btn.dart';
import 'package:vasya_app/widgets/custom_input.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
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
                'Добро пожаловать,\nвойдите в аккаунт',
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(hintText: 'Email...',),
                CustomInput(hintText: 'Password...',),
                CustomBtn(
                  text: 'Войти',
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
                text: 'Создать аккаунт',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
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

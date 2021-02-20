import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/constants.dart';
import 'package:store/screens/code_page.dart';
import 'package:store/widgets/custom_btn.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final controller = TextEditingController();

  String verificationId, otp;

  // Default Form Loading State
  bool _signInFormLoading = false;

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 76),
              child: Text(
                'Добро пожаловать,\nвойдите в аккаунт',
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: controller,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefix: Text('+'),
                      labelText: 'Номер телефона (+X XXX-XXX-XXXX)',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                      border: InputBorder.none,
                      hintText: 'X-XXX-XXX-XXXX',
                      hintStyle: TextStyle(
                        fontSize: 26,
                        letterSpacing: 6,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 18.0,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    buildCounter: (BuildContext context,
                            {int currentLength,
                            int maxLength,
                            bool isFocused}) =>
                        null,
                    style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 14,
                    ),
                  ),
                ),
                CustomBtn(
                  text: 'Подтвердить',
                  outlineBtn: false,
                      onPressed: () {
                    setState(() {
                      _signInFormLoading = true;
                    });
                    if (controller.text.length == 11) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CodePage(controller.text)));
                    } else if(controller.text.isEmpty)ScaffoldMessenger.of(context)
                        .showSnackBar(
                        SnackBar(
                          content: Text('Введите номер телефона!'),
                        ),
                      );
                    else ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Введите корректный номер!'),
                        ),
                      );
                    setState(() {
                      _signInFormLoading = false;
                    });
                  },
                  isLoading: _signInFormLoading,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: CustomBtn(
                isLoading: _signInFormLoading,
                text: 'Продолжить анонимно',
                onPressed: () {
                  setState(() {
                    _signInFormLoading = true;
                  });
                  FirebaseAuth.instance.signInAnonymously();
                },
                outlineBtn: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/services/auth.dart';
import 'package:vasya_app/widgets/custom_btn.dart';
import 'package:vasya_app/widgets/custom_input.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String email;
  String password;
  bool showLogin = true;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
        padding: EdgeInsets.only(top: 60),
        child: Align(
            child: Text('VasyaApp',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white30,
              ),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(45),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1),
                borderRadius: BorderRadius.circular(45),
              ),
              prefixIcon: Padding(
                child: IconTheme(
                  data: IconThemeData(color: Colors.white),
                  child: icon,
                ),
                padding: EdgeInsets.only(left: 10),
              )),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        onPressed: () {
          func();
        },
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
      );
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child:
                  _input(Icon(Icons.email), 'Email', _emailController, false),
            ),
            Container(
              child: _input(
                  Icon(Icons.lock), 'Password', _passwordController, true),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: _button(label, func)),
            )
          ],
        ),
      );
    }

    void _loginButtonAction() async {
      email = _emailController.text;
      password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) return;

      User user = await authService.signInWithEmailAndPassword(
          email.trim(), password.trim());

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Authentication error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    void _registerButtonAction() async {
      email = _emailController.text;
      password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) return;

      User user = await authService.registerWithEmailAndPassword(
          email.trim(), password.trim());

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Registration error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

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
                'Добро пожаловать,\n войдите в аккаунт',
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(),
                CustomInput(),
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
                  print('Clicked the create account btn');
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

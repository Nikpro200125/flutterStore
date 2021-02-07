import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/screens/register.dart';
import 'package:vasya_app/widgets/custom_btn.dart';
import 'package:vasya_app/widgets/custom_input.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  // Default Form Loading State
  bool _signInFormLoading = false;

  // From Input Fields Values
  String _signInEmail = '';
  String _signInPassword = '';

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Error dialog
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Container(
              child: Text(
                error,
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Закрыть'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // Create a new user account
  Future<String> _signInAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _signInEmail.trim(),
        password: _signInPassword.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Слабый пароль. Пароль  дожен содержать хотя бы 6 символов';
      } else if (e.code == 'email-already-in-use') {
        return 'Пользователь с такой почтой уже существует.';
      } else if (e.code == 'invalid-email') {
        return 'Почта имеет неверый формат';
      } else if (e.code == 'unknown') {
        return 'Ошибка авторизации';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  // Submit Form Btn
  void _submitForm() async {
    setState(() {
      _signInFormLoading = true;
    });
    String _createAccountFeedback = await _signInAccount();
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _signInFormLoading = false;
      });
    }
  }

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
                CustomInput(
                  hintText: 'Email...',
                  onChanged: (value) {
                    _signInEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  isPassword: true,
                  hintText: 'Password...',
                  onChanged: (value) {
                    _signInPassword = value;
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                  focusNode: _passwordFocusNode,
                ),
                CustomBtn(
                  text: 'Войти',
                  outlineBtn: false,
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _signInFormLoading,
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

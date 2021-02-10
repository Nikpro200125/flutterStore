import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class CodePage extends StatefulWidget {
  final String phone;

  CodePage(this.phone);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String verificationId;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 50,
            ),
            child: Column(
              children: [
                Text(
                  'Подтверждение',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                Text(
                  '\n+${widget.phone}',
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
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
                    labelText: 'Код подтверждения',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                    border: InputBorder.none,
                    hintText: '* * * * * *',
                    hintStyle: TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 18.0,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 6,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  style: TextStyle(
                    fontSize: 26,
                    letterSpacing: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: CustomBtn(
                  text: 'Отправить',
                  onPressed: () {
                    if (controller.text.length != 6)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Введите корректный код'),
                        ),
                      );
                    else
                      signIn(controller.text);
                  },
                ),
              ),
            ],
          ),
          Container(
            child: CustomBtn(
              text: 'Вернуться',
              outlineBtn: true,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  Future<void> verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+' + widget.phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
          ),
        );
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> signIn(String otp) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Неверный код'),
          ),
        );
        await Future.delayed(
          Duration(
            seconds: 3,
          ),
        );
      } else
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      await Future.delayed(
        Duration(
          seconds: 3,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error'),
        ),
      );
      await Future.delayed(
        Duration(
          seconds: 3,
        ),
      );
    }
    Navigator.pop(context);
  }
}

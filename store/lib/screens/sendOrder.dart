import 'package:flutter/material.dart';
import 'package:store/firebase_service.dart';
import 'package:store/widgets/custom_action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class SendOrder extends StatefulWidget {
  @override
  _SendOrderState createState() => _SendOrderState();
}

class _SendOrderState extends State<SendOrder> {
  final FirebaseService firebaseService = FirebaseService();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'ФИО',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Введите ФИО';
                      }
                      return null;
                    },
                    maxLength: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CustomBtn(
                      onPressed: () {
                        save();
                      },
                      text: 'Сохранить',
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomActionBar(
            title: "Оформление заявки",
            hasBackArrow: true,
          ),
        ],
      ),
    );
  }

  void save() async{
    setState(() {
      isLoading = true;
    });
    bool c;
    await firebaseService.usersRef
        .doc(firebaseService.firebaseUser)
        .collection('cart')
        .get()
        .then(
          (value) {
        value.docs.forEach(
              (element) {
            if (firebaseService.productsRef.doc(element.id) == null) {
              c = false;
            }
          },
        );
      },
    );
    if (c)
      print('`````````````````````1');
    else
      print('`````````````````````0');
  }
}

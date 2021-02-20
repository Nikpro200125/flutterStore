import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/firebase_service.dart';
import 'package:store/screens/landing.dart';
import 'package:store/widgets/custom_action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class AddCategory extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          CustomActionBar(
            hasBackArrow: true,
            title: 'Добавление категории',
            hasCartCounter: false,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            margin: EdgeInsets.only(
              top: 100,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Название категории',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Введите название';
                      }
                      return null;
                    },
                    maxLength: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: image == null
                          ? Text('изображение не выбрано')
                          : Image.file(
                              File(image.path),
                              height: 150,
                              width: 300,
                            ),
                    ),
                  ),
                  CustomBtn(
                    onPressed: getImage,
                    text: 'выбрать изображение',
                    outlineBtn: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CustomBtn(
                      onPressed: () {
                        save();
                      },
                      text: 'Сохранить',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(
      () {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print('Изображение не выбрано');
        }
      },
    );
  }

  Future save() async {
    if (_formKey.currentState.validate()) if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Изображение не выбрано'),
        ),
      );
    } else {
      Reference firebaseStorage = FirebaseStorage.instance.ref().child(
            'images/categories/${image.path.split('/').last}',
          );
      await firebaseStorage
          .putFile(File(image.path))
          .catchError(
            (e) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ошибка'),
              ),
            ),
          )
          .whenComplete(
            () => {
              firebaseStorage.getDownloadURL().then(
                (value) {
                  imageUrl = value;
                  widget.firebaseService.categoriesRef.add(
                    {
                      'name': nameController.text,
                      'logo': imageUrl,
                    },
                  );
                },
              )
            },
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Категория добавлена'),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ),
        (route) => false,
      );
    }
  }
}

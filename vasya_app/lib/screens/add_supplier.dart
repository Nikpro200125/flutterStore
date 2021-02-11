import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/landing.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class AddSupplier extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();
  final Map<String, bool> l;

  AddSupplier(this.l);

  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String dropDown;
  bool loading = false;

  @override
  void dispose() {
    priceController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomActionBar(
            hasBackArrow: true,
            title: 'Добавление поставщика',
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
                      hintText: 'Название поставщика',
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
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Описание поставщика',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите описание';
                        }
                        return null;
                      },
                      maxLength: 1000,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 50,
                    ),
                    child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Средняя цена поставщика',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите цену';
                        }
                        return null;
                      },
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: image == null
                          ? Text('изображение не выбрано')
                          : Image.file(
                              image,
                              height: 150,
                              width: 300,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Center(
                      child: Text(
                        'Выберите категории',
                        style: Constants.regularHeading,
                      ),
                    ),
                  ),
                  Column(
                    children: widget.l.keys.map((String key) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: widget.l[key],
                        onChanged: (bool value) {
                          setState(() {
                            widget.l[key] = value;
                          });
                        },
                      );
                    }).toList(),
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
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('Изображение не выбрано');
      }
    });
  }

  Future save() async {
    if (_formKey.currentState.validate()) if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Изображение не выбрано'),
        ),
      );
      setState(() {
        loading = false;
      });
    } else {
      Reference firebaseStorage = FirebaseStorage.instance.ref().child(
            'images/${image.path.split('/').last}',
          );
      await firebaseStorage
          .putFile(image)
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
                      'description': descriptionController.text,
                      'price': int.parse(priceController.text),
                    },
                  );
                },
              )
            },
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Поставщик добавлен'),
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

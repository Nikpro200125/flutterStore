import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/landing.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class AddProduct extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();
  final QuerySnapshot suppliers;
  final List<DropdownMenuItem> categories;

  AddProduct(this.categories, this.suppliers);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> _suppliers;
  String category;
  String supplier;

  @override
  void dispose() {
    priceController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (category != null)
      _suppliers = widget.suppliers.docs
          .where((element) => List.castFrom(element.data()['categories']).contains(category))
          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                child: Text(e.data()['name'].toString()),
                value: e.data()['name'].toString(),
              ))
          .toList();
    return Scaffold(
      body: Stack(
        children: [
          CustomActionBar(
            hasBackArrow: true,
            title: 'Добавление товара',
            hasCartCounter: false,
          ),
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
                      hintText: 'Название товара',
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
                        hintText: 'Описание товара',
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
                        hintText: 'Цена товара',
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
                  DropdownButtonFormField(
                    hint: widget.categories.length == 0 ? Text('Нет доступных категорий') : Text('Выберите категорию'),
                    validator: (value) {
                      if (supplier == null) return "Выберите категорию";
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        category = newValue;
                        supplier = null;
                      });
                    },
                    value: category,
                    items: widget.categories,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: widget.categories.length == 0 ? Colors.black : Theme.of(context).accentColor,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  if (category != null)
                    DropdownButtonFormField(
                      hint: _suppliers.length == 0 ? Text('Нет доступных поставщиков') : Text('Выберите поставщика'),
                      validator: (value) {
                        if (supplier == null) return "Выберите поставщика";
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() {
                          supplier = newValue;
                        });
                      },
                      value: supplier,
                      items: _suppliers,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: _suppliers.length == 0 ? Colors.black : Theme.of(context).accentColor,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: image == null
                          ? Text(
                              'изображение не выбрано',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Image.file(
                              image,
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        }
      },
    );
  }

  Future save() async {
    if (_formKey.currentState.validate()) if (image == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Изображение не выбрано'),
        ),
      );
    } else if (double.tryParse(priceController.text) == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Некорректная цена'),
        ),
      );
    } else {
      Reference firebaseStorage = FirebaseStorage.instance.ref().child(
            'images/products/${image.path.split('/').last}',
          );
      await firebaseStorage
          .putFile(image)
          .catchError((e) => Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка'),
                ),
              ))
          .whenComplete(
        () {
          firebaseStorage.getDownloadURL().then(
            (value) {
              imageUrl = value;
              widget.firebaseService.productsRef.add(
                {
                  'name': nameController.text,
                  'logo': imageUrl,
                  'description': descriptionController.text,
                  'price': double.parse(priceController.text),
                  'category': category,
                  'supplier': supplier,
                  'search_string': getSearchString(nameController.text),
                },
              );
            },
          );
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Товар добавлен'),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(),
            ),
            (route) => false,
          );
        },
      );
    }
  }
  List<String> getSearchString(String name){
    List<String> x = [];
    name.split(' ').forEach((element){
      String temp = "";
      for (int i = 0; i < element.length; i++) {
        temp += element[i];
        x.add(temp);
      }
    });
    return x;
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/firebase_service.dart';
import 'package:store/widgets/action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class EditProduct extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();
  final QuerySnapshot suppliers;
  final String docId;
  final DocumentSnapshot product;
  final List<DropdownMenuItem> categories;

  EditProduct(this.categories, this.suppliers, this.docId, this.product);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController priceController;
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> _suppliers;
  String category;
  String supplier;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.data()['name']);
    priceController =
        TextEditingController(text: widget.product.data()['price'].toString());
    descriptionController =
        TextEditingController(text: widget.product.data()['description']);
    imageUrl = widget.product.data()['logo'];
    category = widget.product.data()['category'];
    supplier = widget.product.data()['supplier'];
  }

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
          .where((element) =>
              List.castFrom(element.data()['categories']).contains(category))
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
                    hint: widget.categories.length == 0
                        ? Text('Нет доступных категорий')
                        : Text('Выберите категорию'),
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
                      color: widget.categories.length == 0
                          ? Colors.black
                          : Theme.of(context).accentColor,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  if (category != null)
                    DropdownButtonFormField(
                      hint: _suppliers.length == 0
                          ? Text('Нет доступных поставщиков')
                          : Text('Выберите поставщика'),
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
                        color: _suppliers.length == 0
                            ? Colors.black
                            : Theme.of(context).accentColor,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  if (image == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: imageUrl == null
                            ? Text('изображение отсутствует')
                            : Image.network(
                                imageUrl,
                                height: 150,
                                width: 300,
                              ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: image == null
                            ? Text('изображение отсутствует')
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
    getSearchString(nameController.text);
    if (_formKey.currentState.validate()) {
      if (double.tryParse(priceController.text) == null)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Некорректная цена'),
          ),
        );
      else if (image == null) {
        widget.firebaseService.productsRef.doc(widget.docId).update(
          {
            'name': nameController.text,
            'description': descriptionController.text,
            'price': double.parse(priceController.text),
            'category': category,
            'supplier': supplier,
            'search_string': getSearchString(nameController.text),
          },
        );
      } else {
        Reference firebaseStorage = FirebaseStorage.instance.ref().child(
              'images/products/${image.path.split('/').last}',
            );
        await firebaseStorage
            .putFile(image)
            .catchError((e) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка'),
                  ),
                ))
            .whenComplete(() {
          firebaseStorage.getDownloadURL().then(
            (value) {
              imageUrl = value;
              widget.firebaseService.productsRef.doc(widget.docId).update(
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
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Товар обновлен'),
        ),
      );
      Navigator.pop(context);
    }
  }

  List<String> getSearchString(String name) {
    List<String> x = [];
    name.toLowerCase().split(' ').forEach(
      (element) {
        String temp = "";
        for (int i = 0; i < element.length; i++) {
          temp += element[i];
          x.add(temp);
        }
      },
    );
    return x;
  }
}

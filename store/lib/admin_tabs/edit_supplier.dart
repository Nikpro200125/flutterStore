import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/widgets/custom_action_bar.dart';
import 'package:store/widgets/custom_btn.dart';

class EditSupplier extends StatefulWidget {
  final String docId;
  final FirebaseService firebaseService = FirebaseService();
  final Map<String, bool> l;
  final DocumentSnapshot supplier;

  EditSupplier(this.l, this.docId, this.supplier);

  @override
  _EditSupplierState createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController priceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.supplier.data()['name']);
    priceController = TextEditingController(text: widget.supplier.data()['averageprice'].toString());
    descriptionController = TextEditingController(text: widget.supplier.data()['description']);
    imageUrl = widget.supplier.data()['logo'];
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
    return Scaffold(
      body: Stack(
        children: [
          CustomActionBar(
            hasBackArrow: true,
            title: 'Добавление поставщика',
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
                  FormField(
                    validator: (value) {
                      if (!widget.l.values.contains(true)) {
                        return "error";
                      }
                      return null;
                    },
                    builder: (context) => Column(
                      children: widget.l.keys.map(
                        (String key) {
                          return CheckboxListTile(
                            title: Text(key),
                            value: widget.l[key],
                            onChanged: (bool value) {
                              setState(
                                () {
                                  widget.l[key] = value;
                                },
                              );
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  CustomBtn(
                    onPressed: getImage,
                    text: 'заменить изображение',
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
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  Future save() async {
    if (double.tryParse(priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Некорректная средняя цена'),
        ),
      );
      return;
    }
    Map<String, bool> x = {...widget.l};
    x.removeWhere((key, value) => !value);
    if (_formKey.currentState.validate()) {
      if (image == null) {
        widget.firebaseService.suppliersRef.doc(widget.docId).update(
          {
            'name': nameController.text,
            'description': descriptionController.text,
            'averageprice': double.parse(priceController.text),
            'categories': x.keys.toList(),
          },
        );
      } else {
        Reference firebaseStorage = FirebaseStorage.instance.ref().child(
              'images/suppliers/${image.path.split('/').last}',
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
            .whenComplete(() {
          firebaseStorage.getDownloadURL().then(
            (value) {
              imageUrl = value;
              widget.firebaseService.suppliersRef.doc(widget.docId).update(
                {
                  'name': nameController.text,
                  'logo': imageUrl,
                  'description': descriptionController.text,
                  'averageprice': double.parse(priceController.text),
                  'categories': x.keys.toList(),
                },
              );
            },
          );
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Поставщик обновлен'),
        ),
      );
      Navigator.pop(context);
    }
  }
}

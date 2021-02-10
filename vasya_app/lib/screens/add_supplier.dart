import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  File image;
  String imageUrl;
  final picker = ImagePicker();
  final nameController = TextEditingController();

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
                  RaisedButton(
                    onPressed: getImage,
                    child: Text(
                      'выбрать изображение',
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        save();
                      },
                      child: Text('Сохранить'),
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
      } else {
        print('No image selected.');
      }
    });
  }

  Future save() async {
    Reference firebaseStorage = FirebaseStorage.instance.ref().child(
      'images/${image.path.split('/').last}',
    );
    await firebaseStorage.putFile(image).whenComplete(
          () => {
        firebaseStorage.getDownloadURL().then(
              (value) {
            imageUrl = value;
            FirebaseFirestore.instance.collection('categories').add(
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
  }
}

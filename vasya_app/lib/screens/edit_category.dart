import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vasya_app/firebase_service.dart';
import 'package:vasya_app/screens/landing.dart';
import 'package:vasya_app/widgets/custom_action_bar.dart';
import 'package:vasya_app/widgets/custom_btn.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final FirebaseService firebaseService = FirebaseService();

  EditCategory({this.docId});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController controllerName;
  File image;
  final picker = ImagePicker();
  String imageUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 100,
              left: 12,
              right: 12,
            ),
            child: FutureBuilder(
              future:
                  widget.firebaseService.categoriesRef.doc(widget.docId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text(snapshot.error),
                  );

                if (snapshot.connectionState == ConnectionState.done) {
                  controllerName =
                      TextEditingController(text: snapshot.data.data()['name']);
                  imageUrl = snapshot.data.data()['logo'];
                  return Stack(
                    children: [
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Введите название';
                                }
                                return null;
                              },
                              controller: controllerName,
                              maxLength: 100,
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
                              text: 'заменить изображение',
                              outlineBtn: true,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
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
                      Container(
                        child: CustomBtn(
                          onPressed: () async {
                            await widget.firebaseService.categoriesRef
                                .doc(widget.docId)
                                .delete()
                                .whenComplete(
                              () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(),
                                  ),
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Категория удалена'),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'Удалить',
                          outlineBtn: true,
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          CustomActionBar(
            title: 'Редактирование категории',
            hasBackArrow: true,
            hasCartCounter: false,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controllerName.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  Future save() async {
    if (_formKey.currentState.validate()) {
      if (image == null) {
        widget.firebaseService.categoriesRef.doc(widget.docId).update(
          {
            'name': controllerName.text,
          },
        ).catchError(
              (e) =>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка'),
                ),
              ),
        );
      } else {
        Reference firebaseStorage = FirebaseStorage.instance.ref().child(
          'images/${image.path
              .split('/')
              .last}',
        );
        await firebaseStorage
            .putFile(image)
            .catchError(
              (e) =>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка'),
                ),
              ),
        )
            .whenComplete(
              () =>
          {
            firebaseStorage.getDownloadURL().then(
                  (value) {
                imageUrl = value;
                widget.firebaseService.categoriesRef.doc(widget.docId).update(
                  {
                    'name': controllerName.text,
                    'logo': imageUrl,
                  },
                );
              },
            )
          },
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Категория изменена'),
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

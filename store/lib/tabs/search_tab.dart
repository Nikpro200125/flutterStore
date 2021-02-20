import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/firebase_service.dart';
import 'package:store/widgets/custom_input.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final FirebaseService firebaseService = FirebaseService();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (searchString.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "Результаты поиска",
                  style: Constants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: firebaseService.productsRef
                  .where('search_string', arrayContains: searchString).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        "Ошибка ${snapshot.error}",
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 128.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data.docs.map(
                      (document) {
                        return Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFFF4EADE),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 12,
                                  left: 24,
                                ),
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    "${document.data()['logo']}",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 25,
                                      ),
                                      child: Text(
                                        "${document.data()['name']}",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Color(0xFF2988BC),
                                        ),
                                      ),
                                      width: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Искать тут...",
              onChanged: (value) {
                setState(
                  () {
                    searchString = value.toLowerCase();
                  },
                );
              },
              onSubmitted: (value) {
                setState(
                  () {
                    searchString = value.toLowerCase();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

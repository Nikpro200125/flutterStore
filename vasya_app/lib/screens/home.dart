import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vasya_app/constants.dart';
import 'package:vasya_app/screens/add_category.dart';
import 'package:vasya_app/tabs/home_tab.dart';
import 'package:vasya_app/tabs/cart_tab.dart';
import 'package:vasya_app/tabs/search_tab.dart';
import 'package:vasya_app/widgets/bottom_tabs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: ListView(
                children: [
                  Text(
                    'Свой Базар\n',
                    style: Constants.regularHeading,
                  ),
                  if (!FirebaseAuth.instance.currentUser.isAnonymous)
                    Text(
                      'Вы вошли с аккаунта',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  if (!FirebaseAuth.instance.currentUser.isAnonymous)
                    Text(
                      '${FirebaseAuth.instance.currentUser.email}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
            ),
            if (!FirebaseAuth.instance.currentUser.isAnonymous)
              ListTile(
                title: Text('История заказов'),
                onTap: () {
                  //
                },
              ),
            if (FirebaseAuth.instance.currentUser.email == Constants.adminEmail)
              ListTile(
                title: Text('Добавить Категорию'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCategory(),
                    ),
                  );
                },
              ),
            if (FirebaseAuth.instance.currentUser.email == Constants.adminEmail)
              ListTile(
                title: Text('Добавить Поставщика'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            if (FirebaseAuth.instance.currentUser.email == Constants.adminEmail)
              ListTile(
                title: Text('Добавить Товар'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            if (!FirebaseAuth.instance.currentUser.isAnonymous)
              ListTile(
                title: Text(
                  'Выйти',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              controller: _pageController,
              children: [
                HomeTab(),
                SearchTab(),
                CartTab(),
              ],
            ),
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (num) {
              setState(
                () {
                  _selectedTab = num;
                  _pageController.animateToPage(
                    num,
                    duration: Duration(microseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

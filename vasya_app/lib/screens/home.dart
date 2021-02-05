import 'package:flutter/material.dart';
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

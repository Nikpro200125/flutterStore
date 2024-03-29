import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2.0,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            path: "assets/images/tab_home.png",
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabBtn(
            path: "assets/images/tab_search.png",
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
            path: "assets/images/tab_cart.png",
            selected: _selectedTab == 2 ? true : false,
            onPressed: () {
              widget.tabPressed(2);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String path;
  final bool selected;
  final Function onPressed;

  BottomTabBtn({this.path, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
            ),
          ),
        ),
        child: Image(
          image: AssetImage(path),
          height: 22.0,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}

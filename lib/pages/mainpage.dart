import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ia/pages/overview.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/pages/login.dart';
import 'package:ia/pages/ws.dart';
import 'package:ia/pages/livegame.dart';
import 'package:ia/pages/activetables.dart';
import 'package:ia/tools/drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:ia/tools/globals.dart' as globals;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _page = 0;
  final MyDrawer _drawer = new MyDrawer();

  FocusNode focus = new FocusNode();

  List pageNames = ["Feed", "Tables"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.red,
      body: new PageView(
        children: [
          new ActiveTableView(),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      appBar: !focus.hasFocus ? defaultAppBar() : searchAppBar(),
      /*
      bottomNavigationBar: new BottomNavigationBar(
        fixedColor: Colors.blue,
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.play_circle_outline), title: new Text("Active tables")),
        ],
        onTap: navigationTap,
        currentIndex: _page,
      ),
      */
      drawer: _drawer,
    );
  }

  AppBar defaultAppBar() {
    return new AppBar(
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: _page==0 ? new Icon(null): new Icon(Icons.search),
            onPressed: () => setState(() {
                  FocusScope.of(context).requestFocus(focus);
                  print("Focus " + focus.hasFocus.toString());
                }),
          ),
        ],
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(pageNames[_page], textAlign: TextAlign.right),
          ],
        ));
  }

  AppBar searchAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: new TextField(
        focusNode: focus,
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
        ),
      ),
    );
  }

  void navigationTap(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
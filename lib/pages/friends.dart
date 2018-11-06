// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/main.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/tools/drawer.dart';

//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

final MyDrawer _drawer = new MyDrawer();

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FriendsView(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/overview': return new MyCustomRoute(
            builder: (_) => new FoosballApp(),
            settings: settings,
          );
          case '/profile': return new MyCustomRoute(
            builder: (_) => new ProfilePage(),
            settings: settings,
          );
          case '/friends': return new MyCustomRoute(
            builder: (_) => new FriendsPage(),
            settings: settings,
          );
          case '/leaderboards': return new MyCustomRoute(
            builder: (_) => new LeaderboardPage(),
            settings: settings,
          );
          case '/settings': return new MyCustomRoute(
            builder: (_) => new SettingsPage(),
            settings: settings,
          );
          case '/about': return new MyCustomRoute(
            builder: (_) => new AboutPage(),
            settings: settings,
          );
        }
        assert(false);
      },
    );
  }
}

class FriendsView extends StatefulWidget {
  @override
  createState() => new FriendsViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class FriendsViewState extends State<FriendsView> {
  FocusNode focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: !focus.hasFocus ? defaultAppBar() : searchAppBar(),
      body: new ListView(
        padding: new EdgeInsets.all(10.0),
        children: <Widget>[
          new Card(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  //   padding: new EdgeInsets.all(5.0),
                  child: new Container(
                    padding: new EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Username",
                          style: new TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                          ),
                        ),
                        new Text("Rank"),
                      ],
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                    padding: new EdgeInsets.all(8.0),
                    child:new Icon(
                      Icons.done,
                      color: Colors.green[500],
                    ),
                    ),
                  ],
                )
              ],
            ),
          ),
          new Card(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  //   padding: new EdgeInsets.all(5.0),
                  child: new Container(
                    padding: new EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Username",
                          style: new TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                          ),
                        ),
                        new Text("Rank"),
                      ],
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                    padding: new EdgeInsets.all(8.0),
                    child:new Icon(
                      Icons.person_add,
                      color: Colors.red[500],
                    ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      drawer: _drawer,
    );
  }

  AppBar defaultAppBar() {
    return new AppBar(
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () => setState(() {
                  print("Focus " + focus.hasFocus.toString());
                  FocusScope.of(context).requestFocus(focus);
                }),
          ),
        ],
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Friends'),
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
}

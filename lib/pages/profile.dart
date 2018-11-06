// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';
import 'package:ia/main.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/tools/drawer.dart';
import 'package:ia/tools/colortile.dart';

//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

final MyDrawer _drawer = new MyDrawer();

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ProfileView(),
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

class ProfileView extends StatefulWidget {
  @override
  createState() => new ProfileViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class ProfileViewState extends State<ProfileView> {
  double winrate = 0.5;
  final ValueChanged<Color> colorChanged = null;
  Color selected = Colors.blue;

  void onColorChange(Color color){
    print("selected "+selected.toString());
    setState((){
      selected = color;
    }
    );
    print("colorchange "+color.toString());
    selected = color;
    print("selected "+selected.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: selected,
        centerTitle: true,
        title: new Text('Profile'),
      ),
      body: new ListView(
        children: <Widget>[
          new DrawerHeader(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/drawer.jpg'),
                fit: BoxFit.fill,
              ),
              //insert image or what ever profile pic stuff here
            ),
            //  margin: new EdgeInsets.only(bottom: 0.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new CircleAvatar(
                      radius: 45.0,
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.white,
                    ),
                    new Container(
                      height: 10.0,
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Text(
                      'Username here',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  "WinRate",
                  textAlign: TextAlign.left,
                  style: new TextStyle(height: 3.0, fontSize: 22.0),
                ),
                new Container(
                  padding: new EdgeInsets.all(20.0),
                  child: new LinearProgressIndicator(
                      value: winrate, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  "Rank",
                  textAlign: TextAlign.left,
                  style: new TextStyle(height: 2.0, fontSize: 22.0),
                ),
                new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: new Text(
                      "3 of 10",
                      style: new TextStyle(
                        fontSize: 30.0,
                        height: 1.0,
                      ),
                    )),
              ],
            ),
          ),
          new Card(
            child: new Column(
              children: <Widget>[
                new Text(
                  'Pick your color',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 22.0,
                    height: 2.0,
                  ),
                ),
                new ColorPickerGrid(
                  rowsize: 10,
                  selected: selected,
                  rounded: true,
                  colors:[
                      Colors.red,
                      Colors.orange,
                      Colors.green,
                      Colors.purple,
                      Colors.blue,
                      Colors.yellow,
                      Colors.cyan,
                      Colors.lightGreen,
                      Colors.pink[300],
                      Colors.teal,
                    ],
                    onTap: (color){
                      onColorChange(color);
                      
                      print("asd "+color.toString());
                    },
                    ),
              ],
            ),
          )
        ],
      ),
      drawer: _drawer,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ia/main.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/pages/ws.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Container(
          child: new ListView(
        children: <Widget>[
          /*
            new AppBar(
                automaticallyImplyLeading: false,
                title: new Text('Menu'),
             ),
             */
          new DrawerHeader(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/drawer.jpg'),
                fit: BoxFit.fill,
              ),
              //insert image or what ever profile pic stuff here
            ),
            //  margin: new EdgeInsets.only(bottom: 0.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  'Menu',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                new Container(
                  height: 20.0,
                ),
                new CircleAvatar(
                  radius: 30.0,
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                )
              ],
            ),
          ),
          new ListTile(
            title: new Text('Overview'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/overview');
            },
          ),
          new ListTile(
            title: new Text('Profile'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          new ListTile(
            title: new Text('Friends'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/friends');
            },
          ),
          new ListTile(
            title: new Text('Leaderboards'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/leaderboards');
            },
          ),
          new ListTile(
            title: new Text('Livegame'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/livegamelist');
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text('Settings'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/settings');
            },
          ),
          new ListTile(
            title: new Text('Websocket test'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/ws');
            },
          ),
          new ListTile(
            title: new Text('About'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/about');
            },
          ),
        ],
      )),
    );
  }
}

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

final MyDrawer _drawer = new MyDrawer();

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new AboutView(),
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

class AboutView extends StatefulWidget {
  
  @override
  createState() => new AboutViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class AboutViewState extends State<AboutView> {

   @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        drawer: _drawer,
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new Text('Hello World'),
        ),
      ),
    );
  }

}


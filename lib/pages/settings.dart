import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:ia/main.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/mainpage.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/tools/globals.dart' as globals;
import 'package:ia/tools/drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SettingsView(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/overview': return new MyCustomRoute(
            builder: (_) => new MainPage(),
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

class SettingsView extends StatefulWidget {
  
@override
  createState() => new SettingsViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class SettingsViewState extends State<SettingsView> {
  
final usernameController = TextEditingController();

   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: new Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          new TextField(
              controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
          ),
          new MaterialButton(
                    elevation: 4,
                    height: 45.0,
                    color: Colors.green[600],
                    onPressed: (){
                      globals.user_id = usernameController.text;
                    },
                    child: new Text("Change name",style: TextStyle(color: Colors.white),),
                  ),
        ],
      ),
    );
  }
}


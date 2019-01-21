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
import 'package:ia/pages/mainpage.dart';
import 'package:ia/pages/ws.dart';
import 'package:ia/pages/livegame.dart';
import 'package:ia/pages/activetables.dart';
import 'package:ia/tools/drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(new FoosballApp());
  getDevice();
  }
  
  Future getDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    print('A id on ${androidInfo.androidId}');
    print('Hardware on ${androidInfo.hardware}');
    print('Id on ${androidInfo.id}');
    print('Version on ${androidInfo.version}');
    

}

final MyDrawer _drawer = new MyDrawer();


//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class FoosballApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'IAFoosball',
  //    home: new MainPage(),
      home: new Login(primaryColor: Colors.red,backgroundColor: Colors.grey[200],backgroundImage: AssetImage("images/login.png")),
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.lightBlue[600],
        
        // Define the default Font Family
        fontFamily: 'Montserrat',
        
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home': return new SlideRightRoute(
            widget: new MainPage(),
          );
          case '/overview': return new MyCustomRoute(
            builder: (_) => new MainPage(),
            settings: settings,
          );
          case '/profile': return new SlideRightRoute(
            widget: new ProfilePage(),
            //settings: settings,
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
          case '/ws': return new MyCustomRoute(
            builder: (_) => new WebsocketTest(),
            settings: settings,
          );
          case '/livegamelist': return new MyCustomRoute(
            builder: (_) => new ActivetableList(),
            settings: settings,
          );
          /*
          case '/livegame': return new MyCustomRoute(
            builder: (_) => new Livegame(matchID: matchID,),
            settings: settings,
          );
          */
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


class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    // Fades between routes. (If you don't want any animation, 
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
    : super(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
           );
         }
      );
}
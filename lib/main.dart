import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ia/pages/overview.dart';
import 'package:ia/pages/friends.dart';
import 'package:ia/pages/settings.dart';
import 'package:ia/pages/about.dart';
import 'package:ia/pages/profile.dart';
import 'package:ia/pages/leaderboards.dart';
import 'package:ia/pages/tableoverview.dart';
import 'package:ia/pages/ws.dart';
import 'package:ia/pages/livegame.dart';
import 'package:ia/pages/activetables.dart';
import 'package:ia/tools/drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:ia/tools/globals.dart' as globals;

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
    globals.user_id = androidInfo.hardware+"-_-"+androidInfo.androidId;
}

final MyDrawer _drawer = new MyDrawer();


//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class FoosballApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'IAFoosball',
      home: new MainPage(),
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


class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _page = 0;


  FocusNode focus = new FocusNode();

  List pageNames = ["Feed", "Tables"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.red,
      body: new PageView(
        children: [
          new Overview(),
          new ActiveTableView(),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      appBar: !focus.hasFocus ? defaultAppBar() : searchAppBar(),
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

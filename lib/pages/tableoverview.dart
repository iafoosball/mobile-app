
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

class Tableoverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new TableView(),
    );
  }
}

class TableView extends StatefulWidget {
  @override
  createState() => new TableViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class TableViewState extends State<TableView> {
  FocusNode focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                          "Tablename",
                          style: new TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                          ),
                        ),
                        new Text("tablelocation"),
                      ],
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                    padding: new EdgeInsets.all(8.0),
                    child:new Icon(
                      Icons.star,
                      color: Colors.yellow,
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
                          "Tablename",
                          style: new TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                          ),
                        ),
                        new Text("tablelocation"),
                      ],
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                    padding: new EdgeInsets.all(8.0),
                    child:new Icon(
                      Icons.remove,
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
}

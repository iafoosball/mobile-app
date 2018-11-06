// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  
  @override
  createState() => new HomeViewState();
}

final TextEditingController _controller = new TextEditingController();
//final ValueChanged<String> onChanged;

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      primary: true,
      resizeToAvoidBottomPadding: true,
      body: new ListView(
          children: [
            new Image(
             image: new AssetImage( "images/foosball_table.jpg"),
              width: 600.0,
              height: 240.0,
            ),
            tableCode,
          ],
      ),
    );
  }
  Widget tableCode = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  width: 200.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    'Login to table',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                new Container(
                  width: 200.0,
                  child: new TextField(
                    onChanged: _onChanged,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    maxLengthEnforced: true,
                    style: new TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 14.0
                    ),
                    textAlign: TextAlign.center,
                    controller: _controller,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: InputBorder.none,
                      counterStyle: new TextStyle(
                        fontSize: 0.0
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  
  sideMenu(){
    print("clicked");
  }
//TODO add server stuff and go to lobby
  static void _onChanged(String text){
    print("asd "+text);
  }

}


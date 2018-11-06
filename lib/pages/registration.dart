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
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
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


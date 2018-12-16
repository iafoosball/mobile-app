// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner:false,
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
            new FeedCard("Feed example, tournament"),
            new FeedCard("Another example, news"),

          ],
      ),
    );
  }

  
  sideMenu(){
    print("clicked");
  }
//TODO add server stuff and go to lobby
  static void _onChanged(String text){
    print("asd "+text);
  }

}

class FeedCard extends StatelessWidget{
  final String text;

  FeedCard(this.text);

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 1.5,
      child: new Container(
        padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(text,style: new TextStyle(fontSize: 20.0),),
              Align(child: new Icon(Icons.more_vert),alignment: Alignment.topLeft)
              
            ],
          ),
          new Container(
            padding: EdgeInsets.all(4.0),
            child:
              Text(
        '''
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
        ''',
        softWrap: true,
      ),
          )
        ],
      ),
      ),
    );
  }

}


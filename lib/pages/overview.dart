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
Rediscover your passion with our new technology. We measure goals and goal speed and much more and make the information available to the palm of your hand. Compare yourself against your friends, meet up for casual games, create tournaments and how you and your friends perform. You can also create tournaments and challenge friends.
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


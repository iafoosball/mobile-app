
import 'package:flutter/material.dart';
import 'package:ia/objects/live_item.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:ia/tools/globals.dart' as globals;

class Livegame extends StatelessWidget {
  final String tableID;
  Livegame({@required this.tableID});

@override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //home: new LivegameView(channel: IOWebSocketChannel.connect("ws://iafoosball.aau.dk:9003/users/"+tableID+"/user-1")),
      home: new LivegameView(channel: IOWebSocketChannel.connect("ws://"+globals.server+":"+globals.port+"/users/"+tableID+"/"+globals.user_id)),
    );
  }
  
}

class LivegameView extends StatefulWidget {
  
final WebSocketChannel channel;


  LivegameView({@required this.channel});

  @override
  createState() => new LivegameViewState();
  
}

class LivegameViewState extends State<LivegameView> with TickerProviderStateMixin {
  String _SelectdType = "1v1";
  SidekickController controller;
  Animation<double> animation;
  AnimationController acontroller;

  String userID = "user-1";

  @override
  void initState(){
    controller =
        SidekickController(vsync: this, duration: Duration(seconds: 1));
        acontroller = new AnimationController(vsync: this,
        duration: new Duration(seconds: 4));
        Tween blueAtt = new Tween<double>(begin: 10.0, end: 180.0);
        animation = blueAtt.animate(acontroller);
        super.initState();
        animation.addListener(() {
            setState(() {
            });
        });
  }


   @override
  Widget build(BuildContext context) {
  print("here2");
  
  return new Scaffold(
      body:
  StreamBuilder(
    stream: widget.channel.stream,
    builder: (context, snapshot) {
                if (snapshot.hasError){
                  print("snapshot errrrror "+snapshot.error.toString()+" data "+snapshot.data.toString());
                }
                print(snapshot.connectionState);
                print(snapshot.data);

                var toreturn = new Scaffold(body:Center(child: CircularProgressIndicator()));

                if(snapshot.hasData){
                var userpositions = new Map(); 
                LiveItem matchitem = LiveItem.fromJson(json.decode(snapshot.data));
                if(matchitem.positions!=null){
                if(matchitem.positions.blueAttack!=null){
                  userpositions[matchitem.positions.blueAttack] = "bAtt";
                }
                if(matchitem.positions.blueDefense!=null){
                  userpositions[matchitem.positions.blueDefense] = 'bDef';

                }
                if(matchitem.positions.redAttack!=null){
                  userpositions[matchitem.positions.redAttack] = 'rAtt';

                }
                if(matchitem.positions.redDefense!=null){
                  userpositions[matchitem.positions.redDefense] = 'rDef';

                }
                }
                matchitem.started != null&& matchitem.started==true ? 
              //  matchitem.started == null ? 
              //Livegame view
                toreturn = new Scaffold(
                    body: new Padding(
                    padding: new EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                    child: new Column( 
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Score
                        new Expanded(
                          flex: 1,
                          child:
                          new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new BText("Red")
                              ],
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,

                              children: <Widget>[
                                new BText(matchitem.scoreRed.toString())
                              ],
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,

                              children: <Widget>[
                                new BText("-")
                              ],
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,

                              children: <Widget>[
                                new BText(matchitem.scoreBlue.toString())
                              ],
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,

                              children: <Widget>[
                                new BText("Blue")
                              ],
                            ),
                          ],
                        ),
                        ),
                        new Expanded(
                          flex: 10,
                          child:
                        new Container(
                          alignment: Alignment.topLeft,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("images/foosball.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: new Container (
                              child:new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:<Widget>[ 
                                  //redside
                                new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                   new RedSide(widget.channel, matchitem),
                                ],
                              ),
                              new Padding(padding: EdgeInsets.all(8),),
                              //blueside
                                new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new BlueSide(widget.channel, matchitem),
                                ],
                              ),
                              ]
                              ),
                            ),
                        ),
                        ),


                        new Divider(
                        color: Colors.black54,
                      ),
                      //Option button
                      new Row(
                         mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("end game"));
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.green,
                                child: new Text("End game",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                      new Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal red"));
                                widget.channel.sink.add('{ "command": "addGoal", "values": { "speed": 1, "side": "red", "position": "attack"  }}');
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.red,
                                child: new Text("+1 goal red",style: new TextStyle(color: Colors.white)),
                              ),
                            ),
                            ]
                            ),
                            new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal red"));
                                Scaffold.of(context).showSnackBar(snackBar);
                                widget.channel.sink.add('{ "command": "removeGoal", "values": { "side": "red" }}');
                              },
                              child: new Container(
                                margin: EdgeInsets.all(2.0),
                                padding:EdgeInsets.all(10.0),
                                color: Colors.red,
                                child: new Text("-1 goal red",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],),
                        new Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal blue"));
                                Scaffold.of(context).showSnackBar(snackBar);
                                widget.channel.sink.add('{ "command": "addGoal", "values": { "speed": 1, "side": "blue", "position": "attack"  }}');
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.blue,
                                child: new Text("+1 goal blue",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                          ),
                          new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal blue"));
                                widget.channel.sink.add('{ "command": "removeGoal", "values": { "side": "blue" }}');
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.blue,
                                child: new Text("-1 goal blue",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],
                      ),
                        ]
                      ),


                        /*
                        new Expanded(
                          child:
                            new Container (
                              padding: new EdgeInsets.all(8.0),
                              child:new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:<Widget>[ Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new BlueSide(widget.channel, matchitem),
                                  //Red side
                                  new RedSide(widget.channel, matchitem),
                                ],
                              ),
                              ]
                              ),
                            ),
                        )
                        */
                      ],
                    ),
                    )
                )
                
                /*
                new Scaffold(
                  body: new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: new Column( 
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Container(
                                color: Color.fromARGB(100, 255, 0, 0),
                                child: new Row(
                                  children: <Widget>[
                                    new Text("Red ",
                                      style: new TextStyle(
                                        fontSize: 40.0,
                                      ),
                                      textAlign: TextAlign.left
                                      ),
                                      new Container(
                                      color:Colors.red,
                                      child: new Text(matchitem.scoreRed.toString(),
                                      style: new TextStyle(
                                        fontSize: 40.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center
                                      ),
                                      ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                          
                          new Text(":",
                          style: new TextStyle(
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.center
                          ),
                          new Container(
                          color:Colors.blue,
                          child: new Text(matchitem.scoreBlue.toString(),
                          style: new TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center
                          ),
                          ),
                          new Text("Blue ",
                          style: new TextStyle(
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.right
                          ),
                        ]
                      ),
                      ),
                      //Text side row
                      new Expanded(
                      child: new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:<Widget>[ Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new BlueSide(widget.channel, matchitem),
                          //Red side
                          new RedSide(widget.channel, matchitem),
                        ],
                      ),
                      new Text("Admin options",style:new TextStyle(fontSize: 16.0)),
                      new Divider(
                        color: Colors.black54,
                      ),
                      //Option button
                      new Row(
                         mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("end game"));
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.green,
                                child: new Text("End game",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                      new Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal red"));
                                widget.channel.sink.add('{ "command": "addGoal", "values": { "speed": 1, "side": "red", "position": "attack"  }}');
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.red,
                                child: new Text("+1 goal red",style: new TextStyle(color: Colors.white)),
                              ),
                            ),
                            ]
                            ),
                            new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal red"));
                                Scaffold.of(context).showSnackBar(snackBar);
                                widget.channel.sink.add('{ "command": "removeGoal", "values": { "side": "red" }}');
                              },
                              child: new Container(
                                margin: EdgeInsets.all(2.0),
                                padding:EdgeInsets.all(10.0),
                                color: Colors.red,
                                child: new Text("-1 goal red",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],),
                        new Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal blue"));
                                Scaffold.of(context).showSnackBar(snackBar);
                                widget.channel.sink.add('{ "command": "addGoal", "values": { "speed": 1, "side": "blue", "position": "attack"  }}');
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.blue,
                                child: new Text("+1 goal blue",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                          ),
                          new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal blue"));
                                widget.channel.sink.add('{ "command": "removeGoal", "values": { "side": "blue" }}');
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.blue,
                                child: new Text("-1 goal blue",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],
                      ),
                        ],
                      ),
                        ],
                      )
                      ),
                      ),
                    ],
                  ),
                  ),
                )
                */
                : 
                //Lobby view
                toreturn = new Scaffold(
                  body: new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:
                      new Text("Pick a position",
                      style: new TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center
                      ),
                      ),
                      //Text side row
                      new Expanded(
                      child: new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:<Widget>[ Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      new Expanded(
                          flex: 10,
                          child:
                        new Container(
                          alignment: Alignment.topLeft,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("images/foosball.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: new Container (
                              child:new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:<Widget>[ 
                                  //redside
                                new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                   new RedSide(widget.channel, matchitem),
                                ],
                              ),
                              new Padding(padding: EdgeInsets.all(8),),
                              //blueside
                                new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new BlueSide(widget.channel, matchitem),
                                ],
                              ),
                              ]
                              ),
                            ),
                        ),
                        ),
                        ],
                      ),
                      new Padding(padding: EdgeInsets.all(4.0),),
                      //Settings dropdown
                      new Text("Settings",style:new TextStyle(fontSize: 16.0)),
                      new Divider(
                        color: Colors.black54,
                      ),
                      new DropdownButton<String>(
                        items: <String>['1v1', '2v2', 'Switch', 'tournament'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint:Text(_SelectdType),
                        onChanged: (String val) {
                          print(val);
                          _SelectdType = val;
                          String toserver = val.replaceAll("1v1", "oneOnOne").replaceAll("2v2", "twoOnTwo").replaceAll("2v1", "twoOnOne");
                          widget.channel.sink.add('{ "command": "settings", "values": { "'+toserver+'": true }}');
                          setState(() {});
                        },
                      ),
                      //Start button
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[new GestureDetector(
                            onTap: () {
                              final snackBar = SnackBar(content: Text("Start game"));
                              Scaffold.of(context).showSnackBar(snackBar);
                              widget.channel.sink.add('{ "command": "started"}'); 
                            },
                            child: new Container(
                              padding:EdgeInsets.all(10.0),
                              color: Colors.green,
                              child: new Text("Start game",style: new TextStyle(color: Colors.white)),
                            )
                          ),
                          ]
                          ),
                        ],
                      ),
                      ),
                      ),
                      //Spectators
                      new GestureDetector(
                        onTap: (){
                          print("Join spectator");
                          widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "spectator", "position": "null" }}');
                          
                        },
                        child: new Row(
                          children: <Widget>[
                            new Text("Spectators   join",style:new TextStyle(fontSize: 16.0)),
                            new Icon(FontAwesomeIcons.plus)
                          ],
                        )

                        
                      ),
                      new Divider(
                        color: Colors.black54,
                      ),
                      new Container(
                        padding: new EdgeInsets.all(8.0),
                        height: 100.0,
                        child:new ListView.builder(
                            itemExtent: 100.0,
                            physics: new BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                              itemCount: matchitem.users.length,
                              itemBuilder: (BuildContext context, i) {
                                if(userpositions.containsKey(matchitem.users[i].id)){

                                  return null;
                                }else{

                                return new Sidekick(
                                  tag: "s_user-1",
                                  child: 
                                  new CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.blueGrey,
                                    child:new Text(matchitem.users[i].id)
                                    ));
                                }
                              },
                      ),
                      ),
                    ],
                  ),
                  ),
                );
                }

                return toreturn;
      }
  )
  );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
    controller?.dispose();
  }
}

class BText extends StatelessWidget{
  final String text;

  BText(this.text);

  @override
  Widget build(BuildContext context){
    return Text(text,style: new TextStyle(fontSize: 20.0),);
  }

}

class BlueSide extends StatelessWidget{

final WebSocketChannel channel;
final LiveItem matchitem;

BlueSide(this.channel,this.matchitem);

  @override
  Widget build(BuildContext context){
    return new Expanded(
      flex: 1,
      child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
      //  new Text("Blue side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
      new GestureDetector(
              onTap: () {
                final snackBar = SnackBar(content: Text("Blue def"));
                Scaffold.of(context).showSnackBar(snackBar);
                channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "defense" }}');
              },
              child: matchitem.positions.blueDefense != null ? 
              new CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child:
                      new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                    new Icon(FontAwesomeIcons.shieldAlt,size: 15.0),
                                    new  Text(matchitem.positions.blueDefense),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
              )
              )
              :
              new CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30.0,
                child: new Icon(FontAwesomeIcons.shieldAlt,size: 30.0),
              )),      
        new Padding(padding: EdgeInsets.all(32),),
        new GestureDetector(
              onTap: () {
                final snackBar = SnackBar(content: Text("Blue att"));
                Scaffold.of(context).showSnackBar(snackBar);
                channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "attack" }}');
              },
              child: matchitem.positions.blueAttack != null ? 
              new CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child:
                      new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                    new Icon(FontAwesomeIcons.bullseye,size: 15.0),
                                    new  Text(matchitem.positions.blueAttack),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
              )
              )
              :
              new CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30.0,
                child: new Icon(FontAwesomeIcons.bullseye,size: 30.0),
              )),
          ],
        ),
    );
  }
}

class RedSide extends StatelessWidget {

final WebSocketChannel channel;
final LiveItem matchitem;

RedSide(this.channel,this.matchitem);

@override
  Widget build(BuildContext context) {
  return new Expanded(
    flex: 1,
    child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         // new Text("Red side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
          new GestureDetector(
            onTap: () {
              final snackBar = SnackBar(content: Text("red att"));
              Scaffold.of(context).showSnackBar(snackBar);
              channel.sink.add(' { "command": "setPosition", "values": { "side": "red", "position": "attack" }}');
            },
            child: matchitem.positions.redAttack != null ? 
            new CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child:
                      new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                    new Icon(FontAwesomeIcons.bullseye,size: 15.0),
                                    new  Text(matchitem.positions.redAttack),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
            ))
            :
            new CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30.0,
              child: new Icon(FontAwesomeIcons.bullseye,size: 30.0),
            )),
      
        new Padding(padding: EdgeInsets.all(32),),
      new GestureDetector(
            onTap: () {
              final snackBar = SnackBar(content: Text("Red def"));
              Scaffold.of(context).showSnackBar(snackBar);
              channel.sink.add(' { "command": "setPosition", "values": { "side": "red", "position": "defense" }}');
            },
            child: matchitem.positions.redDefense != null ? 
            new CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child:
                      new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                    new Icon(FontAwesomeIcons.shieldAlt,size: 15.0),
                                    new  Text(matchitem.positions.redDefense),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
            ))
            :
            new CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30.0,
              child: new Icon(FontAwesomeIcons.shieldAlt,size: 30.0),
            )),
        ],
      ),
  );
  }
}



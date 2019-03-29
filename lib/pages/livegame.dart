
import 'dart:io';

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
/*
    SecureSocket secureSocket = await SecureSocket.connect(globals.server+"/users/"+tableID+"/"+globals.user_id, 9003,
          onBadCertificate: (X509Certificate cert) => true);
    WebSocket ws = WebSocket.fromUpgradedSocket(secureSocket);
    */
        return new MaterialApp(
          home: new LivegameView(channel: IOWebSocketChannel.connect("ws://"+globals.server+":9013/users/?tableID="+tableID+"&userID="+globals.user_id)),
          //home: new LivegameView(channel: c)
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
      var spectators = [];
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

      print(matchitem.users.length);
      for(var i = 0;i<matchitem.users.length;i++){
      if(userpositions.containsKey(matchitem.users[i].id)){
          print("Here123123");
      }else{
        print("nothere123123");
        spectators.add(matchitem.users[i].id);
      }
      }

      matchitem.started != null&& matchitem.started==true ? 
    //  matchitem.started == null ? 
    //Livegame view
      toreturn = new Scaffold(
        appBar: new AppBar(
              centerTitle: true,
              backgroundColor: Colors.lightBlue[800],
              title: new Text("Live Match",textAlign: TextAlign.center)
          ),
          body: new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: new Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              
              //Score
            new Card(
              margin: EdgeInsets.only(top: 8.0,bottom: 8.0),
              elevation: 2,
              child: 
              new Container(
                height: 60.0,
                padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
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
              ),
              
            new Card(
              elevation: 2,
              child: 
              new Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/foosball1.png"),
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
            //Option button
            /*
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
                    child: new RoundButtom("End game", Colors.green, "", widget.channel)
                  ),
                  ]
                  ),
              ],
            ),
            */
            new Card(
              elevation: 2,
              child:
              new Container(
                padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                child: 
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
            new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    new GoalBotton("+1 Red", Colors.red[600], '{ "command": "addGoal", "values": { "speed": 0, "side": "red", "position": "attack"  }}', widget.channel)
                  ]
                  ),
                  new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    new GoalBotton("-1 Red", Colors.red[600], '{ "command": "removeGoal", "values": { "side": "red" }}', widget.channel)
                  ]
                  ),
              ],),
              new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    new GoalBotton("+1 Blue", Colors.blue[600], '{ "command": "addGoal", "values": { "speed": 0, "side": "blue", "position": "attack"  }}', widget.channel)
                  ]
                ),
                new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[new GoalBotton("-1 Blue", Colors.blue[600], '{ "command": "removeGoal", "values": { "side": "blue" }}', widget.channel)
                  ]
                ),
              ],
            ),
            
              ]
            ),
            ),
            ),
            new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  new MaterialButton(
                    elevation: 4,
                    height: 45.0,
                    color: Colors.purple[600],
                    onPressed: (){
                      widget.channel.sink.add('{ "command": "cancelMatch", "values": { }}');
                    },
                    child: new Text("Stopmatch",style: TextStyle(color: Colors.white),),
                  ),
                 // new RoundButtom("Start",Colors.green,'{ "command": "started"}',widget.channel),
                ]
            )
            ],
            ),
            ],
          ),
          )
      )
      : 
      //Lobby view
      toreturn = new Scaffold(
        appBar: new AppBar(
              centerTitle: true,
              backgroundColor: Colors.lightBlue[800],
              title: new Text("Lobby",textAlign: TextAlign.center)
        ),
        body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
        child: new ListView(
          children: <Widget>[
            //Text side row
            new Card(
              margin: EdgeInsets.only(top: 8.0,bottom: 8.0),
              elevation: 2,
              child: 
              new Container(
                height: 70.0,
                padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
              child:new BText("Pick a position")
              ),
            ),
            new Card(
                child:
              new Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/foosball1.png"),
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

            //Settings dropdown
            new Card(
              elevation: 2.0,
              margin: EdgeInsets.only(top: 8.0,bottom: 8.0),
              child:
              new Column(
              children:<Widget>[
            new Container(
              child: new Text("Settings",style:new TextStyle(fontSize: 24.0),textAlign: TextAlign.center,),
            ),
            new Container(
              alignment: Alignment(0, 0),
              child: 
              //new Text("2v2",style: TextStyle(fontSize: 20.0),),
              
            new DropdownButton<String>(
              elevation: 8,
              items: <String>['1v1', '2v2', 'Switch', 'Tournament Mode'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              hint:Text(_SelectdType),
              onChanged: (String val) {
                print(val);
                _SelectdType = val;
                String toserver = val.replaceAll("1v1", "oneOnOne").replaceAll("2v2", "twoOnTwo").replaceAll("2v1", "twoOnOne").replaceAll("Tournament Mode", "tournamentMode");
                widget.channel.sink.add('{ "command": "settings", "values": { "'+toserver+'": true }}');
                setState(() {});
              },
            ),
            ),
            //Start button
            
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  new MaterialButton(
                    elevation: 4,
                    height: 45.0,
                    color: Colors.green[600],
                    onPressed: (){
                      widget.channel.sink.add('{ "command": "started"}');
                    },
                    child: new Text("Start",style: TextStyle(color: Colors.white),),
                  ),
                 // new RoundButtom("Start",Colors.green,'{ "command": "started"}',widget.channel),
                ]
            ),
            
            new Padding(
        padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),),
                ]
              ),
            ),

            //Spectators
            new Card(
              elevation: 2.0,
              child: new Column(
                children: <Widget>[
            new Container(
              height: 40.0,
              child:    
            new GestureDetector(
              onTap: (){
                print("Join spectator");
                widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "spectator", "position": "null" }}');
                
              },
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("Spectators",style:new TextStyle(fontSize: 24.0)),
                  new Icon(Icons.add)
                ],
              )

              
            ),
            ),
            new Container(
              height: 60.0,
              child:new ListView.builder(
                  itemExtent: 80.0,
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    itemCount: spectators.length,
                    itemBuilder: (BuildContext context, i) {
                      return new CircleAvatar(
                          backgroundColor: Colors.blueGrey[800],
                          radius: 30.0,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                flex: 1,
                                child:
                                new ListView(
                                  padding: new EdgeInsets.all(14.0),
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                              new  Text(spectators[i],style: TextStyle(color: Colors.white),),
                                      ]
                                    ),
                                  ],
                                )
                              ),
                            ],
                        )
                        );
                    },
            ),
            ),
            new Padding(
        padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),),
          ],
        ),
        ),
                ],
              ),
            )
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



class GoalBotton extends StatelessWidget{

  final String text;
  final String command;
  final Color color;
  final WebSocketChannel channel;

  GoalBotton(this.text,this.color,this.command,this.channel);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        final snackBar = SnackBar(content: Text(text));
        Scaffold.of(context).showSnackBar(snackBar);
        channel.sink.add(command); 
      },
      child: new MaterialButton(
          color: color,
                height: 40.0,
                child: new Text(text,style: TextStyle(color: Colors.white),)
      )
      
      /*new Container(
        padding:EdgeInsets.all(10.0),
        color: Colors.green,
        child: new Text("Start game",style: new TextStyle(color: Colors.white)),
      )*/
    );
  }
}

class RoundButtom extends StatelessWidget{

  final String text;
  final String command;
  final Color color;
  final WebSocketChannel channel;

  RoundButtom(this.text,this.color,this.command,this.channel);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        final snackBar = SnackBar(content: Text(text));
        Scaffold.of(context).showSnackBar(snackBar);
        channel.sink.add(command); 
      },
      child: new CircleAvatar(
          backgroundColor: color,
                radius: 40.0,
                child: new BText(text)
      )
      
      /*new Container(
        padding:EdgeInsets.all(10.0),
        color: Colors.green,
        child: new Text("Start game",style: new TextStyle(color: Colors.white)),
      )*/
    );
  }
}

class BText extends StatelessWidget{
  final String text;

  BText(this.text);

  @override
  Widget build(BuildContext context){
    return Text(text,style: new TextStyle(fontSize: 30.0),);
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
                backgroundColor: Colors.blue[600],
                radius: 50.0,
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
                                    new  Text(matchitem.positions.blueDefense,style: TextStyle(color: Colors.white,fontSize: 20.0),),
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
                backgroundColor: Colors.blue[600],
                radius: 50.0,
                child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
              )),      
        new Padding(padding: EdgeInsets.all(60),),
        new GestureDetector(
              onTap: () {
                final snackBar = SnackBar(content: Text("Blue att"));
                Scaffold.of(context).showSnackBar(snackBar);
                channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "attack" }}');
              },
              child: matchitem.positions.blueAttack != null ? 
              new CircleAvatar(
                backgroundColor: Colors.blue[600],
                radius: 50.0,
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
                                    new  Text(matchitem.positions.blueAttack,style: TextStyle(color: Colors.white,fontSize: 20.0),),
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
                backgroundColor: Colors.blue[600],
                radius: 50.0,
                child: new Icon(FontAwesomeIcons.bullseye,size: 50.0),
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
              backgroundColor: Colors.red[600],
              radius: 50.0,
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
                                    new  Text(matchitem.positions.redAttack,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
            ))
            :
            new CircleAvatar(
              backgroundColor: Colors.red[600],
              radius: 50.0,
              child: new Icon(FontAwesomeIcons.bullseye,size: 50.0),
            )),
      
        new Padding(padding: EdgeInsets.all(60),),
      new GestureDetector(
            onTap: () {
              final snackBar = SnackBar(content: Text("Red def"));
              Scaffold.of(context).showSnackBar(snackBar);
              channel.sink.add(' { "command": "setPosition", "values": { "side": "red", "position": "defense" }}');
            },
            child: matchitem.positions.redDefense != null ? 
            new CircleAvatar(
              backgroundColor: Colors.red[600],
              radius: 50.0,
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
                                    new Icon(FontAwesomeIcons.shieldAlt,size: 20.0),
                                    new  Text(matchitem.positions.redDefense,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
            ))
            :
            new CircleAvatar(
              backgroundColor: Colors.red[600],
              radius: 50.0,
              child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
            )),
        ],
      ),
  );
  }
}




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
      home: new LivegameView(channel: IOWebSocketChannel.connect("ws://192.168.0.129:9003/users/"+tableID+"/"+globals.user_id)),
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
                  appBar: new AppBar(
                    title: new Text("Live game"),
                    leading: new Text(snapshot.connectionState.toString()),
                  ),
                  body: new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: new Column( 
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("Red ",
                          style: new TextStyle(
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.center
                          ),
                          new Container(
                          color:Colors.red,
                          child: new Text("1 ",
                          style: new TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center
                          ),
                          ),
                          new Text(":",
                          style: new TextStyle(
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.center
                          ),
                          new Container(
                          color:Colors.blue,
                          child: new Text("2 ",
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
                          textAlign: TextAlign.center
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
                      
                          //Blue side
                          new Expanded(
                            flex: 1,
                            child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Text("Blue side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
                              new GestureDetector(
                                    
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Blue Att"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    },
                                    child: 
                              new CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 50.0,
                                child: new Icon(FontAwesomeIcons.bullseye,size: 50.0),
                              ),),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new GestureDetector(
                                    onTap: () {
                                      matchitem.positions.blueDefense != null ? 
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Position taken")))
                                      :
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Blue def")));
                                      print("Set pos");
                                      widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "defense" }}');
                                      
                                    },
                                    child: matchitem.positions.blueDefense != null ? 
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Text(matchitem.positions.blueDefense),
                                    )
                                    :
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
                                    )),
                                ],
                              ),
                          ),
                          //Red side
                          new Expanded(
                            flex: 1,
                            child:
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("Red side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
                                  new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Red Att"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    },
                                    child: new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.gavel,size: 50.0,),
                                    ),
                                  ),
                              
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Red def"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    },
                                    child:
                              new CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 50.0,
                                child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
                              )),
                                ],
                              ),
                          ),
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
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal red"));
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                padding:EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(2.0),
                                color: Colors.red,
                                child: new Text("-1 goal red",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("-1 goal blue"));
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
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal blue"));
                                Scaffold.of(context).showSnackBar(snackBar);
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
                          new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[new GestureDetector(
                              onTap: () {
                                final snackBar = SnackBar(content: Text("+1 goal red"));
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: new Container(
                                margin: EdgeInsets.all(2.0),
                                padding:EdgeInsets.all(10.0),
                                color: Colors.red,
                                child: new Text("+1 goal red",style: new TextStyle(color: Colors.white)),
                              )
                            ),
                            ]
                            ),
                        ],
                      ),
                        ],
                      ),
                      ),
                      ),
                    ],
                  ),
                  ),
                )
                : 
                //Lobby view
                toreturn = new Scaffold(
                  appBar: new AppBar(
                    title: new Text("Lobby"),
                    leading: new Text(snapshot.connectionState.toString()),
                  ),
                  body: new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: new Column( 
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container (
                      padding: new EdgeInsets.all(8.0),
                      child:
                      new Text("Gamemode",
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
                      
                          //Blue side
                          new Expanded(
                            flex: 1,
                            child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Text("Blue side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
                              new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Blue att"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "attack" }}');
                                    },
                                    child: matchitem.positions.blueAttack != null ? 
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(FontAwesomeIcons.bullseye,size: 20.0),
                                          new  Text(matchitem.positions.blueAttack),
                                        ],
                                    )
                                    )
                                    :
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.bullseye,size: 50.0),
                                    )),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Blue def"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "blue", "position": "defense" }}');
                                    },
                                    child: matchitem.positions.blueDefense != null ? 
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(FontAwesomeIcons.shieldAlt,size: 20.0),
                                          new  Text(matchitem.positions.blueDefense),
                                        ],
                                    )
                                    )
                                    :
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
                                    )),
                                ],
                              ),
                          ),
                          //Red side
                          new Expanded(
                            flex: 1,
                            child:
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("Red side",textAlign: TextAlign.center,style: new TextStyle(fontSize:16.0,height: 2.0)),
                                  new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("red att"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "red", "position": "attack" }}');
                                    },
                                    child: matchitem.positions.redAttack != null ? 
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(FontAwesomeIcons.bullseye,size: 20.0),
                                          new  Text(matchitem.positions.redAttack),
                                        ],
                                    ))
                                    :
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.bullseye,size: 50.0),
                                    )),
                              
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new GestureDetector(
                                    onTap: () {
                                      final snackBar = SnackBar(content: Text("Red def"));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      widget.channel.sink.add(' { "command": "setPosition", "values": { "side": "red", "position": "defense" }}');
                                    },
                                    child: matchitem.positions.redDefense != null ? 
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(FontAwesomeIcons.shieldAlt,size: 20.0),
                                          new  Text(matchitem.positions.redDefense),
                                        ],
                                    ))
                                    :
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: new Icon(FontAwesomeIcons.shieldAlt,size: 50.0),
                                    )),
                                ],
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
                      new Text("Spectators",style:new TextStyle(fontSize: 16.0)),
                      new Divider(
                        color: Colors.black54,
                      ),
                      new Container(
                        padding: new EdgeInsets.all(8.0),
                        height: 120.0,
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
                      ),),
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

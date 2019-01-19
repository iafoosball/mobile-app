import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ia/objects/match_item.dart';
import 'package:ia/visualObjects/activetablelistrow.dart';
import 'package:isolate/isolate.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:ia/tools/globals.dart' as globals;

class ActivetableList extends StatelessWidget {
/*
Future<List<MatchItem>> fetchTablesInBackground(http.Client client) async {
  // Spawn a Isolate and wait for it to be ready
  final runner = await IsolateRunner.spawn();
  return runner
      // Run the fetchPhotos function inside the isolate
      .run(fetchTables, client)
      // Shut the isolate down after the operation is complete
      .whenComplete(() => runner.close());
}
*/
@override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ActiveTableView(),
    );
  }
}

class ActiveTableView extends StatefulWidget {
@override
  createState() => new ActiveTableViewState();
}

class ActiveTableViewState extends State<ActiveTableView> {
 var refreshKey = GlobalKey<RefreshIndicatorState>();
 List<MatchItem> list;

@override
  void initState() {
    super.initState();
    fetchTables();
  }
  

Future<List<MatchItem>> fetchTables() async {
  print("Here1");
  Uri url = Uri.parse('https://'+globals.server+':'+globals.port+'/matches');
  var client = new HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var request = await client.getUrl(url);
  var response = await request.close();
  var responseBytes = (await response.toList()).expand((x) => x);
  print(new String.fromCharCodes(responseBytes));
  client.close();

    setState(() {
      list = parseTables(new String.fromCharCodes(responseBytes));
    });

  refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    return null;
}

List<MatchItem> parseTables(String responseBody) {
  print("Parsetables");
  print(responseBody);
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed.map<MatchItem>((json) => MatchItem.fromJson(json)).toList());
  return parsed.map<MatchItem>((json) => MatchItem.fromJson(json)).toList();
}


@override
  Widget build(BuildContext context) {
    return new Scaffold(
      
      body: 
      new RefreshIndicator(
          onRefresh: fetchTables,
          key: refreshKey,
          child: list==null||list.length == 0 ? new ListView(
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
                                      "No matches",
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                        height: 2.0,
                                      ),
                                    ),
                                    new Text("Find a table and create one"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                  :
                  new ListView.builder(
            itemExtent: 180.0,
              itemCount: list.length,
              itemBuilder: (BuildContext context, i) {
                return new ActivetableListRow(list[i]);
              },
        )
        )
      
      /*FutureBuilder<List<MatchItem>>(
              future: fetchTables(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print("snapshot errrrror "+snapshot.error.toString()+" data "+snapshot.data.toString());
                var toreturn = null;
                
                if(snapshot.hasData){
                  List<MatchItem> matchitems = snapshot.data;
                  matchitems.length == 0 ? toreturn = new ListView(
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
                                        "No matches",
                                        style: new TextStyle(
                                          fontSize: 20.0,
                                          height: 2.0,
                                        ),
                                      ),
                                      new Text("Find a table and create one"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  )
                  :
                  toreturn = new RefreshIndicator(
                    onRefresh: fetchTables,
                    key: refreshKey,
                    child: new ListView.builder(
                      itemExtent: 180.0,
                      physics: new BouncingScrollPhysics(),
                        itemCount: matchitems.length,
                        itemBuilder: (BuildContext context, i) {
                          return new ActivetableListRow(matchitems[i]);
                        },
                  )
                  );
                  return toreturn;
                }else{
                  toreturn = Center(child: CircularProgressIndicator());
                }

                return toreturn;
              },
            ),
            */
    );
  }
  
}


class ActivetablesList extends StatelessWidget {
  final List<MatchItem> matchitems;

  ActivetablesList({Key key, this.matchitems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
  }
}

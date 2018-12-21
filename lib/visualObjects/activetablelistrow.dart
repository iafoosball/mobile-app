import 'package:flutter/material.dart';
import 'package:ia/objects/match_item.dart';
import 'package:ia/pages/livegame.dart';


class ActivetableListRow extends StatelessWidget {

final MatchItem item;

ActivetableListRow(this.item);

@override
Widget build(BuildContext context) {
  final MatchItemCard = new Card(
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
                        item.tableID,
                        style: new TextStyle(
                          fontSize: 20.0,
                          height: 2.0,
                        ),
                        
                      ),
                      item.scoreBlue == null ? new Text("Game not started") : new Text("Blue score "+item.scoreBlue.toString()+" : "+item.scoreRed.toString()+" Red score"),
                      item.users == null||item.users.length==0 ? new Text("Empty lobby") : new Text("Players in lobby:"),new CreateUsertext(item.users),
                      /*
                      new ListView.builder(
                          itemExtent: 2.0,
                          itemCount: item.users.length,
                          itemBuilder: (BuildContext context, i) {
                            print(item.users[i].username);
                            //new Text(item.users[i].username);
                            new Text("test");
                          },
                    ),
                    */
                    
                    ],
                  ),
                ),
              ),
              new Column(
                children: <Widget>[
                  new Container(
                  padding: new EdgeInsets.all(8.0),
                  child:new Icon(
                    item.started ? Icons.access_time : Icons.add,
                    color: item.started ? Colors.red : Colors.green,
                  ),
                  ),
                ],
              )
            ],
          ),
        );
  return new Container(
    height: 120.0,
    margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: new FlatButton(
      onPressed: () => Navigator.push(context,MaterialPageRoute(
                  builder: (context) => Livegame(tableID: item.tableID),
                ),),
      child: new Stack(
        children: <Widget>[
          MatchItemCard,
        ],
      ),
    ),
  );
}
}

class CreateUsertext extends StatelessWidget{


final List<User> list;

CreateUsertext(this.list);

  @override
  Widget build(BuildContext context) {
    String childrenTexts = "";
    for (User user in list) {
      childrenTexts += user.id+", ";
    }
    print(childrenTexts);
    return  new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new  Text(childrenTexts,style: TextStyle(color: Colors.black38),),
        ],
    );
    /*
    return  new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Expanded(
            child:
            new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                          new  Text(childrenTexts,style: TextStyle(color: Colors.black38),),
                  ]
                ),
              ],
            )
          ),
        ],
    );
    */
  }
}
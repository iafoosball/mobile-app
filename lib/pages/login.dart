import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ia/visualObjects/loader.dart';
import 'package:ia/visualObjects/dot.dart';
import 'package:ia/pages/mainpage.dart';
import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ia/tools/globals.dart' as globals;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class Login extends StatelessWidget {

  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;

  Login({
    Key key,
    this.primaryColor, this.backgroundColor, this.backgroundImage
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: this.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new ClipPath(
            clipper: MyClipper(),
            child: Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: this.backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 150.0, bottom: 100.0),
            ),
          ),
          LoginButtons(),
        ],
      ),
      ),
    );
  }
}

class LoginButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginButtonsState();
      }
    }
    
    class LoginButtonsState extends State<LoginButtons>{

      GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

      bool _googleLoad = false;

      void _changeVarG() {
        setState(() {
          _googleLoad = !_googleLoad;
        });
        _handleSignIn();
      }
      bool _facebookLoad = false;

      void _changeVarF() {
        setState(() {
          _facebookLoad = !_facebookLoad;
        });
      }
      bool _loginLoad = false;

      void _changeVarL() {
        setState(() {
          _loginLoad = !_loginLoad;
        });
        print("Login classic");
        print(usernameController.text+"  "+passwordController.text);
        var responsecode = loginFunc(usernameController.text,passwordController.text).then((int value){
        if(value!=200){
          final snackBar = SnackBar(content: Text("Wrong username or password"));
          Scaffold.of(context).showSnackBar(snackBar);
          _loginLoad = false;
        }else{
          globals.user_id = usernameController.text;
          final snackBar = SnackBar(content: Text("Login succesful"));
          Scaffold.of(context).showSnackBar(snackBar);
          /*
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
            */
          Navigator.of(context).pushReplacementNamed("/home");
        }
        }).catchError((){
          final snackBar = SnackBar(content: Text("Login ERROR!"));
          Scaffold.of(context).showSnackBar(snackBar);
        });
        
      }


      final usernameController = TextEditingController();

      final passwordController = TextEditingController();

        @override
        void dispose() {
          // Clean up the controller when the Widget is disposed
          usernameController.dispose();
          passwordController.dispose();
          super.dispose();
        }


      @override
      Widget build(BuildContext context){
        return new Column(
          children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                new Expanded(
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.lock_open,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                new Expanded(
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        Container(
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    splashColor:  Colors.grey[200],
                    color:  Colors.red,
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        new Expanded(
                          child: Container(),
                        ),
                        new Transform.translate(
                          offset: Offset(15.0, 0.0),
                          child: new Container(
                            padding: const EdgeInsets.all(5.0),
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(28.0)),
                              splashColor: Colors.white,
                              color: Colors.white,
                              child: _loginLoad == false ? new Icon(Icons.arrow_forward,size: 25.0,color: Colors.red,):ColorLoader4(dotOneColor: Colors.red, dotTwoColor: Colors.green, dotThreeColor: Colors.blue,dotType: DotType.circle,),
                              onPressed: _changeVarL,
                            ),
                          ),
                        )
                      ],
                    ),
                    onPressed: _changeVarL,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    splashColor: Color(0xFF3B5998),
                    color: Color(0xff3B5998),
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "LOGIN WITH FACEBOOK",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        new Expanded(
                          child: Container(),
                        ),
                        new Transform.translate(
                          offset: Offset(15.0, 0.0),
                          child: new Container(
                            padding: const EdgeInsets.all(5.0),
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(28.0)),
                              splashColor: Colors.white,
                              color: Colors.white,
                              child: _facebookLoad == false ? new Icon(FontAwesomeIcons.facebook,size: 15.0):ColorLoader4(dotOneColor: Colors.lightBlue[200], dotTwoColor: Colors.blue[300], dotThreeColor: Colors.blue[600],dotType: DotType.circle,),
                              onPressed: _changeVarF,
                            ),
                          ),
                        )
                      ],
                    ),
                    onPressed: _changeVarF,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    splashColor: Colors.lightBlue,
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "LOGIN WITH GOOGLE",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        new Expanded(
                          child: Container(),
                        ),
                        new Transform.translate(
                          offset: Offset(15.0, 0.0),
                          child: new Container(
                            padding: const EdgeInsets.all(5.0),
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(28.0)),
                              splashColor: Colors.lightBlue,
                              color: Colors.white,
                              child: _googleLoad == false ? new Icon(FontAwesomeIcons.google,size: 15.0,color: Colors.red,):ColorLoader4(dotOneColor: Colors.red, dotTwoColor: Colors.green, dotThreeColor: Colors.blue,dotType: DotType.circle,),
                              onPressed: _changeVarG,
                            ),
                          ),
                        )
                      ],
                    ),
                    onPressed: _changeVarG,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.transparent,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign up",
                        style: TextStyle(color:  Colors.red),
                      ),
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
          ),
          ],
        );
      }
    }

  Future<int> loginFunc(user,pass) async {
      String username = user;
      String password = pass;
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Uri url = Uri.parse('https://iafoosball.me:8053/oauth/login');
      var client = new HttpClient();
      
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var request = await client.postUrl(url);
      request.headers.set('authorization', basicAuth);
      var response = await request.close();
      
      var responseBytes = (await response.toList()).expand((x) => x);
      String responseString = new String.fromCharCodes(responseBytes);
      print(responseString);
      print(response.statusCode);
      String token = responseString.substring(17,responseString.length-2);
      print(token);
      client.close();
      sleep(new Duration(seconds: 1));
      return response.statusCode;
  }

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.65);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 12.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
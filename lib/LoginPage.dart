import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_markemon/Dashboard.dart';
import 'package:flutter_app_markemon/DatabaseHelper.dart';
import 'package:flutter_app_markemon/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  String _email;
  String _password;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();
  SharedPreferences prefs;

  var dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Entered initState");

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward(); //start animation
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black54,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/backgroundimage_india.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(
                size: _iconAnimation.value * 100,
              ),
              new Form(
                  key: formkey,
                  child: new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.teal,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                                color: Colors.teal, fontSize: 20.0))),
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Enter Email",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                                !val.contains('@') ? 'Invalid Email' : null,
                            onSaved: (val) => _email = val,
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Enter password",
                            ),
                            keyboardType: TextInputType.text,
                            validator: (val) =>
                                val.length < 6 ? 'Password too short' : null,
                            onSaved: (val) => _password = val,
                            obscureText: true,
                          ),
                          new Padding(
                              padding: const EdgeInsets.only(top: 40.0)),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: new Text("Login"),
                            onPressed: submit,
                            splashColor: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  submit() async {
    final form = formkey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode()); //To hide keyboard

    if (form.validate()) {
      form.save();

      Map<String, dynamic> map = {"userEmail": _email, "password": _password};

      //_onLoading(); //To show progres bar in centre
      //await postData(map);

      var future = postData(map);
      new Timer(new Duration(milliseconds: 4), () {
        print('Entered timner');
        // The error-handler is not attached until 5 ms after the future has
        // been received. If the future fails before that, the error is
        // forwarded to the global error-handler, even though there is code
        // (just below) to eventually handle the error.
        future.then((value) {
          navigateToDashboard();
        }, onError: (e) {
          e.toString();
          //handleError(e);
        });
      });

      //await navigateToDashboard();
      /*   .whenComplete(navigateToDashboard)
          .catchError((e) => debugPrint("future error : " + e.toString()));*/
    }
  }

  String url = "http://192.168.15.223:3000/login";

  postData(Map data) async {
    print("URL: " + url + "\n data: " + data.toString());

    //displaySnackBar(); //display snackbar
    http.Response res;

    try {
      res = await http.post(url, body: data); // post api call
      if (res == null || res.statusCode != 200) {
        print('No status code');
        throw new Exception(
            'HTTP request failed, statusCode: ${res?.statusCode}');
      }
    } catch (e) {
      print('Caught exception: ' + e.toString());
    }

    //Navigator.pop(context);

    if (res.statusCode == (200)) {
      Map _user = JSON.decode(res.body);
      print('Entered 1');
      if (_user['error'].toString().compareTo("0") != null) {
        print('Entered 2');
        prefs = await SharedPreferences.getInstance();
        prefs.setBool("logged_in", true);
        print('parsed: ' + _user['status'].toString());
        try {
          //TODO disabled temp
          dbHelper = DatabaseHelper();
          /*User user = await*/ dbHelper.saveUser(_user['status']);

          /*if (user == null)
            _onRefresh();
          else
            print('saved user-> ${user.username}');

          await navigateToDashboard();*/

// return true;
        } catch (e) {
          print(e);
          //return false;
        }
        //getStates();

        //TODO disbaled temp 13-08

        //print('Entered login _user: ' + user.email);

        //TODO enable later
        return 'success';
      } else {
        print('Entered 3');
        return _user['status'];
      }
    } else {
      print('Entered 4');
      //return 'Error';

      return null;
    }

    //return data;
    //performLogin();
  }

  Future<Null> _onRefresh() {
    print('Entered _nRefresh');
    Completer<Null> completer = new Completer<Null>();

    Timer timer = new Timer(new Duration(seconds: 3), () {
      completer.complete();
    });

    return completer.future;
  }

  navigateToDashboard() async {
    print("Entered navigateToDashboard");
    dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    User _user;
    user.then((data) async {
      String email = data.email;

      _user = data;
      print('fut email future: ' + email);
      print('fut email future: ' + _user.email + "\t name: " + _user.username);
    }, onError: (e) {
      print(e);
    });
    //print("Entered navigateToDashboard" + user.toString());

    //dbHelper = DatabaseHelper();

    /*var _userFuture = await dbHelper.getUser();
    print("**: " + _userFuture.toString());*/
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Dashboard(user: _user)));
  }
}

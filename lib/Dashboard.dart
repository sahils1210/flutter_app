import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_markemon/DatabaseHelper.dart';
import 'package:flutter_app_markemon/LoginPage.dart';
import 'package:flutter_app_markemon/MapPage.dart';
import 'package:flutter_app_markemon/User.dart';
import 'package:flutter_app_markemon/UserProfile.dart';

class Dashboard extends StatefulWidget {
  User user;
  Dashboard({Key key, this.user}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

User user;

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Entered initstate');
    try {
      _onRefresh();
    } catch (e) {
      print("Catch error: " + e.toString());
    }
  }

  Future<Null> _onRefresh() {
    print('Entered onRefresh');
    Completer<Null> completer = new Completer<Null>();

    Timer timer = new Timer(new Duration(seconds: 5), () {
      getUserDetails();
      completer.complete();
    });

    return completer.future;
  }

  void getUserDetails() async {
    User _userFuture = await DatabaseHelper().getUser();
    //print('init state ${_userFuture.email}');

    setState(() {
      if (_userFuture == null) {
        print("Main db null");
      } else {
        user = _userFuture;
        print("Main db != null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Dashboard");
    if (user != null) {
      print("Entered Dashboard user-email: " + user.email);
      //print("Entered Dashboard user-email: ${widget.user.email}");
    } else {
      //getUserDetails();
      print("Entered Dashboard re-user-email");
      //  print("Entered Dashboard re-user-email: ${widget.user.email}");
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Today's Discovery"),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => debugPrint("Pressed search bar")),
            IconButton(
              icon: Icon(
                Icons.tune,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                print('Filter button');
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(user.username + " demo app"),
                //accountEmail: new Text("sahils@mediawareonline.com"),
                accountEmail: new Text(user.email),

                currentAccountPicture: new CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.deepPurple
                          : Colors.white,
                  child: new Text("S"),
                  foregroundColor: Colors.black87,
                ),
                otherAccountsPictures: <Widget>[
                  new CircleAvatar(
                    child: new Text("K"),
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              new ListTile(
                  title: new Text("Map"),
                  trailing: new Icon(Icons.arrow_drop_down_circle),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => MapPage(),
                        ));
                    //Navigator.of(context).pushNamed("/a");
                  }),
              new ListTile(
                title: new Text("My Profile"),
                trailing: new Icon(Icons.arrow_drop_up),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserProfile(friend: user)));
                },
              ),
              new Divider(),
              new ListTile(
                  title: new Text("Logout"),
                  trailing: new Icon(Icons.close),
                  onTap: () {
                    //Delet all data from tables
                    DatabaseHelper().deleteAllTables();

                    Navigator.of(context).pop(); //Close on click of icon
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => LoginPage()));
                  }),
            ],
          ),
        ),
        body: new GridView.count(
            crossAxisCount: 1,
            padding: EdgeInsets.all(16.0),
            childAspectRatio: 2 / 1.5,
            scrollDirection: Axis.horizontal,
            children: _buildGridCards(10) // Replace
            ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.blue,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.blue.shade900,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.white))),
          child: new BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, //

            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.mail),
                title: new Text('Map'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile')),
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    print('Entered onTabTapped: ${index}');
    setState(() {
      _currentIndex = index;
    });
  }

  // TODO: Make a collection of cards (102)
  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
      (int index) => Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18.0 / 11.0,
                  child: Image.asset('assets/bi_logo.png'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Title'),
                      SizedBox(height: 8.0),
                      Text('Secondary Text'),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );

    return cards;
  }
}

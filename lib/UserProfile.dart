import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_markemon/User.dart';
import 'package:flutter_app_markemon/ui/FriendDetailHeader.dart';
import 'package:flutter_app_markemon/ui/UserDetailBody.dart';

class UserProfile extends StatefulWidget {
  final User friend;
  // In the constructor, require a Person
  UserProfile({Key key, this.friend}) : super(key: key);

  //UserProfile(this.friend, {User user}) : super();

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final String title;

  final Object avatarTag;
  //User _user;
  @override
  Widget build(BuildContext context) {
    print('_UserProfileState: ' + widget.friend.username);
    //print('_UserProfileState name: ' + user.username);
    /*  var dbHelper = DatabaseHelper();
    Future<User> _userFuture = dbHelper.getUser();
    _userFuture.then((data) async {
      String email = data.email;

      _user = data;
      print('Dashboard email future: ' + email);
      print('Dashboard email future: ' +
          _user.email +
          "\t name: " +
          _user.username);
    }, onError: (e) {
      print(e);
    });*/

    //Build linear gradient for page
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    /* try {
      var friend = _user;
      print('UserProfile friend: ' + friend.email);
    } catch (e) {
      print('Exception friend: $e');
    }*/

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(
                widget.friend,
                //avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new UserDetailBody(widget.friend),
              ),
              //new FriendShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }
}

//Monday-> user profile build
//Tuesday-> Add dynamic DB with DB operations

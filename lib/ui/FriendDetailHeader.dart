import 'package:flutter/material.dart';
import 'package:flutter_app_markemon/User.dart';
import 'package:flutter_app_markemon/ui/DiagonallyCutColoredImage.dart';
import 'package:meta/meta.dart';

class FriendDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  FriendDetailHeader(
    this.friend, {
    @required this.avatarTag,
  });

  final User friend;
  final Object avatarTag;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: "avatarTag",
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(
            "https://github.com/CodemateLtd/FlutterMates/blob/master/images/profile_header_background.png?raw=true"),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle = textTheme.headline
        .copyWith(color: Colors.white, fontStyle: FontStyle.italic);

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(friend.username + '\'s profile', style: followerStyle),
          /*new Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: new Row(
              children: <Widget>[
                //_createCircleBadge(Icons.beach_access, theme.accentColor),
                _createCircleBadge(Icons.camera, Colors.white12),
                _createCircleBadge(Icons.edit, Colors.white12),
              ],
            ),
          ),*/
          //new Text('sahils@mediawareonline.com', style: followerStyle),
        ],
      ),
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      /*child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'Upgrade',
            backgroundColor: theme.accentColor,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              'FOLLOW',
              textColor: Colors.white70,
            ),
          ),
        ],
      ),*/
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              //-----------------------------
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //_createCircleBadge(Icons.beach_access, theme.accentColor),
                    _createCircleBadge(Icons.camera, Colors.white12),
                    _buildAvatar(),
                    _createCircleBadge(Icons.edit, Colors.white12),
                  ],
                ),
              ),

              //------------------------------
              //_buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(theme),
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}

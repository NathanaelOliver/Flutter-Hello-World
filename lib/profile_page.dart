import "package:flutter/material.dart";
import 'auth.dart';
import 'my_home_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MyTemplate(
        user: widget.user,
        title: "Profile Page",
        body: Column(
            children: <Widget>[Center(child: Text(widget.user.username))]));
  }
}

void loadProfilePage(context, User user) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProfilePage(user)));
}

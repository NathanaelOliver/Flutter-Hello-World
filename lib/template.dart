import 'package:flutter/material.dart';
import 'user.dart';
import 'profile_page.dart';

class MyTemplate extends StatefulWidget {
  final User user;
  final String title;
  final Widget body;

  MyTemplate({this.user, this.title = "", this.body});

  @override
  _MyTemplateState createState() => _MyTemplateState();
}

class _MyTemplateState extends State<MyTemplate> {
  void signOut() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
    signOutGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Center(
              child: Text(
            "Settings",
            style: TextStyle(color: Colors.white, fontSize: 36),
          )),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          title: Text("Profile Page"),
          onTap: () => loadProfilePage(context, widget.user),
        ),
        ListTile(
          title: Text("Sign out"),
          onTap: signOut,
        )
      ])),
      body: widget.body,
    );
  }
}

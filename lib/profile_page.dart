import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

void loadProfilePage(context, FirebaseUser user) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProfilePage(user)));
}

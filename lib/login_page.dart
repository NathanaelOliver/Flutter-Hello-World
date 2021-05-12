import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/auth.dart';
import 'package:hello_world/my_home_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyHomePage(user)))
        });
  }

  Widget googleLoginButton() {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: Center(
            child: OutlinedButton(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/google_logo.png'),
                              height: 35),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Sign in with Google",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 25)),
                          )
                        ])),
                onPressed: this.click)));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child:
            Padding(padding: EdgeInsets.all(10), child: googleLoginButton()));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class User {
  String username;
  String id;
  String photoURL;

  User(this.username, this.id);

  User.fromDatabase(String uid, DataSnapshot snapshot) {
    this.username = snapshot.value['username'];
    this.id = uid;
    this.photoURL = snapshot.value['photoURL'];
  }

  User.fromFirebaseUser(FirebaseUser fUser) {
    this.username = fUser.displayName;
    this.id = fUser.uid;
    this.photoURL = fUser.photoUrl;
    saveUser();
  }

  Map<String, dynamic> toJson() {
    return {'username': this.username, 'photoURL': this.photoURL};
  }

  DatabaseReference saveUser() {
    var id =
        FirebaseDatabase.instance.reference().child('users/').child(this.id);
    id.set(this.toJson());
    return id;
  }

  getImage({double size: 100}) {
    if (this.photoURL != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill, image: NetworkImage(this.photoURL))),
      );
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }
}

Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(currentUser.uid == user.uid);

  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child('users/')
      .child(user.uid)
      .once();
  if (dataSnapshot.value == null) {
    return User.fromFirebaseUser(user);
  }

  return User.fromDatabase(user.uid, dataSnapshot);
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

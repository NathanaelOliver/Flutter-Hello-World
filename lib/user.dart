import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class User {
  String username;
  String id;

  User(this.username, this.id);

  User.fromDatabase(DataSnapshot snapshot) {
    username = snapshot.value['username'];
    id = snapshot.value['id'];
  }

  User.fromFirebaseUser(FirebaseUser fUser) {
    username = fUser.displayName;
    id = fUser.uid;
    saveUser();
  }

  Map<String, dynamic> toJson() {
    return {'username': this.username};
  }

  DatabaseReference saveUser() {
    var id =
        FirebaseDatabase.instance.reference().child('users/').child(this.id);
    id.set(this.toJson());
    return id;
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

  return User.fromDatabase(dataSnapshot);
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

import 'user.dart';
import 'package:firebase_database/firebase_database.dart';

class Post {
  String body;
  String author;
  Set usersLiked = {};
  DatabaseReference _id;

  Post(this.body, this.author);

  Post.fromDatabase(value) {
    this.body = value['body'];
    this.author = value['author'];
    if (value['usersLiked'] != null) {
      this.usersLiked = new Set.from(value['usersLiked']);
    }
  }

  void likePost(User user) {
    if (this.usersLiked.contains(user.id)) {
      this.usersLiked.remove(user.id);
    } else {
      this.usersLiked.add(user.id);
    }
    this.update();
  }

  void update() {
    this._id.update(this.toJson());
  }

  void setId(DatabaseReference id) {
    this._id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'author': this.author,
      'usersLiked': this.usersLiked.toList(),
      'body': this.body
    };
  }

  DatabaseReference save() {
    var id = FirebaseDatabase.instance.reference().child('posts/').push();
    id.set(this.toJson());
    return id;
  }
}

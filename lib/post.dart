import 'auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'database.dart';

class Post {
  String body;
  String author;
  Set usersLiked = {};
  DatabaseReference _id;

  Post(this.body, this.author);

  void likePost(User user) {
    if (this.usersLiked.contains(user.id)) {
      this.usersLiked.remove(user.id);
    } else {
      this.usersLiked.add(user.id);
    }
    this.update();
  }

  void update() {
    updatePost(this, this._id);
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
}

Post createPost(value) {
  Map<String, dynamic> attributes = {
    'author': "",
    'usersLiked': [],
    'body': ""
  };
  value.forEach((key, value) => {attributes[key] = value});
  Post post = new Post(attributes['body'], attributes['author']);
  post.usersLiked = new Set.from(attributes['usersLiked']);
  return post;
}

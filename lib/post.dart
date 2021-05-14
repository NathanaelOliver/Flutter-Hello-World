import 'user.dart';
import 'package:firebase_database/firebase_database.dart';

class Post {
  String body;
  String author;
  Set usersLiked = {};
  Set usersDisliked = {};
  DatabaseReference _id;

  Post(this.body, this.author);

  Post.fromDatabase(value) {
    this.body = value['body'];
    this.author = value['author'];
    if (value['usersLiked'] != null) {
      this.usersLiked = new Set.from(value['usersLiked']);
    }
    if (value['usersDisliked'] != null) {
      this.usersDisliked = new Set.from(value['usersDisliked']);
    }
  }

  void likePost(User user) {
    if (this.usersLiked.contains(user.id)) {
      this.usersLiked.remove(user.id);
    } else {
      if (this.usersDisliked.contains(user.id)) {
        this.usersDisliked.remove(user.id);
      }
      this.usersLiked.add(user.id);
    }
    this.update();
  }

  void dislikePost(User user) {
    if (this.usersDisliked.contains(user.id)) {
      this.usersDisliked.remove(user.id);
    } else {
      if (this.usersLiked.contains(user.id)) {
        this.usersLiked.remove(user.id);
      }
      this.usersDisliked.add(user.id);
    }
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
      'userdDisliked': this.usersDisliked.toList(),
      'body': this.body
    };
  }

  DatabaseReference save() {
    var id = FirebaseDatabase.instance.reference().child('posts/').push();
    id.set(this.toJson());
    return id;
  }
}

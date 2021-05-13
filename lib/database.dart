import 'package:firebase_database/firebase_database.dart';
import 'post.dart';
import 'user.dart';

DatabaseReference savePost(Post post) {
  var id = FirebaseDatabase.instance.reference().child('posts/').push();
  id.set(post.toJson());
  return id;
}

void updatePost(Post post, DatabaseReference id) {
  id.update(post.toJson());
}

DatabaseReference saveUser(User user) {
  var id = FirebaseDatabase.instance.reference().child('users/').child(user.id);
  id.set(user.toJson());
  return id;
}

Future<List<Post>> getAllPosts() async {
  DataSnapshot dataSnapshot =
      await FirebaseDatabase.instance.reference().child('posts/').once();
  List<Post> posts = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Post post = createPost(value);
      post.setId(FirebaseDatabase.instance.reference().child('posts/' + key));
      posts.add(post);
    });
  }
  return posts;
}

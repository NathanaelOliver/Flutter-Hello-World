import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'post.dart';
import 'user.dart';

class PostList extends StatefulWidget {
  final List<Post> listItems;
  final User user;

  PostList(this.listItems, this.user);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callback) {
    this.setState(() {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.widget.listItems.length,
        itemBuilder: (context, index) {
          var post = this.widget.listItems[index];
          return Card(
              child: Row(children: <Widget>[
            Expanded(
                child: ListTile(
                    title: Text(post.body), subtitle: Text(post.author))),
            Row(children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.thumb_down),
                      onPressed: () =>
                          this.like(() => post.dislikePost(widget.user)),
                      color: post.usersDisliked.contains(widget.user.id)
                          ? Colors.blue
                          : Colors.black),
                  Center(
                    child: Text(post.usersDisliked.length.toString(),
                        style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
              Column(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () =>
                        this.like(() => post.likePost(widget.user)),
                    color: post.usersLiked.contains(widget.user.id)
                        ? Colors.blue
                        : Colors.black),
                Center(
                  child: Text(post.usersLiked.length.toString(),
                      style: TextStyle(fontSize: 16)),
                )
              ])
            ])
          ]));
        });
  }
}

Future<List<Post>> getAllPosts() async {
  DataSnapshot dataSnapshot =
      await FirebaseDatabase.instance.reference().child('posts/').once();
  List<Post> posts = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Post post = Post.fromDatabase(value);
      post.setId(FirebaseDatabase.instance.reference().child('posts/' + key));
      posts.add(post);
    });
  }
  return posts;
}

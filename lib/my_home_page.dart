import 'package:flutter/material.dart';
import 'user.dart';
import 'post_list.dart';
import 'text_input_widget.dart';
import 'post.dart';
import 'database.dart';
import 'template.dart';

class MyHomePage extends StatefulWidget {
  final User user;
  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text) {
    var post = new Post(text, widget.user.username);
    post.setId(savePost(post));
    this.setState(() {
      posts.add(post);
    });
  }

  void updatePosts() {
    getAllPosts().then((posts) => {
          this.setState(() {
            this.posts = posts;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return MyTemplate(
      user: widget.user,
      title: "Home Page",
      body: Column(
        children: <Widget>[
          Expanded(child: PostList(this.posts, widget.user)),
          TextInputWidget(this.newPost),
        ],
      ),
    );
  }
}

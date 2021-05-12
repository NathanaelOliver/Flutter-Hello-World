import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/profile_page.dart';
import 'post_list.dart';
import 'text_input_widget.dart';
import 'post.dart';
import 'database.dart';

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

class MyTemplate extends StatefulWidget {
  final User user;
  final String title;
  final Widget body;

  MyTemplate({this.user, this.title = "", this.body});

  @override
  _MyTemplateState createState() => _MyTemplateState();
}

class _MyTemplateState extends State<MyTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Center(
              child: Text(
            "Settings",
            style: TextStyle(color: Colors.white, fontSize: 36),
          )),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          title: Text("Profile Page"),
          onTap: () => loadProfilePage(context, widget.user),
        ),
      ])),
      body: widget.body,
    );
  }
}

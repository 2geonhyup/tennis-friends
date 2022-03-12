//post id를 통해 쓴글 목록을 확인,
//글 타고 갈 수 있음
//timestamp를 표시하도록

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/screens/post_screens/court_modifying_screen.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../post_screens/user_post_view.dart';
import '../post_screens/post_view_screen.dart';
import 'package:tennis_friends_demo/functions.dart';

final _firestore = FirebaseFirestore.instance;
bool type = false; //false: 모임, true: 코트
String typeString = "posts";

class UserPostsScreen extends StatefulWidget {
  static String id = "user_posts_screen";
  UserPostsScreen({required this.uid, required this.name});
  String uid;
  String name;

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    type = false;
                    typeString = "posts";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: type ? Colors.white : Color(0xef1ece71),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      border: Border.all(
                        color: type ? Colors.black45 : Color(0xef1ece71),
                        width: 0.5,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40.0),
                    child: Text(
                      "모임",
                      style: TextStyle(
                          color: type ? Colors.black : Colors.white,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    type = true;
                    typeString = "courts";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: !type ? Colors.white : Color(0xef1ece71),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      border: Border.all(
                        color: !type ? Colors.black45 : Color(0xef1ece71),
                        width: 0.5,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40.0),
                    child: Text(
                      "코트",
                      style: TextStyle(
                          color: !type ? Colors.black : Colors.white,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(child: PostsStream(uid: widget.uid)),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${widget.name}님이 쓴 글",
        ),
        centerTitle: true,
      ),
    );
  }
}

class PostBubble extends StatelessWidget {
  PostBubble({required this.post, required this.ampm, required this.postId});

  QueryDocumentSnapshot post;
  String ampm;
  String postId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<UserData>(context, listen: false).userId !=
            post["user-uid"]) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostViewScreen(
                        postId: postId,
                        postType: "posts",
                        userId: post["user-uid"],
                      )));
        } else {
          Navigator.pushNamed(context, UserPostView.id, arguments: {
            "postId": postId,
            "postType": "posts",
          });
        }
      },
      child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.black.withOpacity(0.05), width: 1.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post["title"],
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'SairaCondensed',
                  fontSize: 18,
                  height: 0.8,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${DateFormat('M/d, ${ampm}h시').format((post["time"] as Timestamp).toDate())}",
                style: TextStyle(
                    fontFamily: 'SairaCondensed', fontSize: 18, height: 0.8),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          )),
    );
  }
}

class PostsStream extends StatelessWidget {
  PostsStream({required this.uid});
  String uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(typeString)
          .where("user-uid", isEqualTo: uid)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff27AC84),
            ),
          );
        }
        final posts = snapshot.data!.docs;
        List<Widget> postBubbles = [];
        for (var post in posts) {
          String ampm;
          DateFormat('a').format((post["time"] as Timestamp).toDate()) == "AM"
              ? ampm = "오전"
              : ampm = "오후";
          final postBubble =
              PostBubble(post: post, ampm: ampm, postId: post.id);
          postBubbles.add(postBubble);
        }
        return ListView(
          children: postBubbles,
        );
      },
    );
  }
}

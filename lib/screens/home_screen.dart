import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'post_screens/user_post_view.dart';
import 'post_screens/post_view_screen.dart';
import 'package:tennis_friends_demo/functions.dart';

final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "가까운 유저 순으로 모임이 정렬됩니다",
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
          ],
        ),
        SizedBox(
          //height: 30,
          child: Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        Expanded(child: PostsStream()),
      ],
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
                height: 15,
              ),
              Text(
                post["member"],
                maxLines: 1,
                style: TextStyle(
                    color: Color(0xff888888),
                    fontFamily: 'SairaCondensed',
                    fontSize: 15,
                    height: 0.8),
              ),
            ],
          )),
    );
  }
}

class PostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .where("time", isGreaterThanOrEqualTo: now)
          .orderBy("time", descending: false)
          .limit(300)
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
        if (Provider.of<UserData>(context).location != null) {
          // Map map = {"latitude": 37.586109, "longitude": 127.028901};
          // print(getDistanceLevel(map, context));
          posts.sort((a, b) => getDistanceLevel(a["user-location"], context)
              .compareTo(getDistanceLevel(b["user-location"], context)));
        }
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

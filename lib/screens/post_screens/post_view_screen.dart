import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/components/post_list_view.dart';
import 'package:provider/provider.dart';
import 'post_modifying_screen.dart';
import 'package:tennis_friends_demo/screens/basic_screen.dart';
import 'court_modifying_screen.dart';
import '../basic_screen.dart';
import 'request_sending_screen.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import '../profile_screens/showing_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class PostViewScreen extends StatefulWidget {
  static String id = "post_view_screen";
  PostViewScreen(
      {required this.postId, required this.postType, required this.userId});
  String postId;
  String postType;
  String userId;

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  Map? userMap;
  var _future;

  Future<void> getUser() async {
    final doc = await _firestore.collection("users").doc(widget.userId).get();
    userMap = doc.data();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
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
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: ProfileLittleView(
                  nickName: userMap!["nick-name"],
                  age: userMap!["age"],
                  gender: userMap!["gender"],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowingProfileScreen(
                          userId: widget.userId,
                          userMap: userMap!,
                        ),
                      ));
                },
              ),
              Expanded(
                  child: PostListView(
                postId: widget.postId,
                postType: widget.postType,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RoundedButton(
                        colour: Color(0xff27ac84),
                        title: "신청하기",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestSendingScreen(
                                  postId: widget.postId,
                                  recieverId: widget.userId,
                                  postType: widget.postType,
                                ),
                              ));
                        }),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

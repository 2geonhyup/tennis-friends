import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/screens/sub_screens/user_posts_screen.dart';

class ShowingProfileScreen extends StatefulWidget {
  static String id = 'showing_profile_screen';

  ShowingProfileScreen({required this.userId, required this.userMap});

  String userId;
  Map? userMap;

  @override
  _ShowingProfileScreenState createState() => _ShowingProfileScreenState();
}

class _ShowingProfileScreenState extends State<ShowingProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileLittleView(
              icon: false,
              nickName: widget.userMap!["nick-name"],
              age: widget.userMap!["age"],
              gender: widget.userMap!["gender"],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "성별) ${widget.userMap!["gender"]}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "나이) ${widget.userMap!["age"]}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          "구력) ${widget.userMap!["tennis-age"]}",
                          style: TextStyle(fontSize: 18),
                        )),
                    ConditionalIntroduce(widget.userMap!["introduce"]),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RoundedButton(
                      colour: Color(0xff27AC84),
                      title: "사용자의 글 목록",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPostsScreen(
                                      name: widget.userMap!["nick-name"],
                                      uid: widget.userId,
                                    )));
                      }),
                ),
                SizedBox(
                  height: 10,
                )
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                //   child: RoundedWhiteButton(title: "신고하기", onPressed: () {}),
                // ),
              ],
            ),
          ],
        ));
  }
}

Widget ConditionalIntroduce(String? introduce) {
  if (introduce == null) return SizedBox.shrink();
  return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        "소개) ${introduce}",
        style: TextStyle(fontSize: 18),
      ));
}

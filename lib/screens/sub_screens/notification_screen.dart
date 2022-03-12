import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/screens/profile_screens/showing_profile_screen.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'showing_request_screen.dart';

final _firestore = FirebaseFirestore.instance;

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: PostsStream());
  }
}

class RequestBubble extends StatelessWidget {
  RequestBubble(
      {required this.introduce,
      required this.postMap,
      required this.senderMap,
      required this.ampm,
      required this.senderId,
      required this.check,
      required this.requestId});

  String introduce;
  Map<String, dynamic>? senderMap;
  Map<String, dynamic>? postMap;
  String ampm;
  String senderId;
  bool check;
  String requestId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //TODO: 포스트에 uid가 아닌, 랜덤으로 만든 user id가 들어가도록 고치기(user필드에 docid도 uid에서 랜덤으로 고치기)
        await _firestore
            .collection("users")
            .doc(Provider.of<UserData>(context, listen: false).userId)
            .collection("notifications")
            .doc(requestId)
            .update({
          "check": true,
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowingRequestScreen(
                      userMap: senderMap,
                      introduce: introduce,
                      senderId: senderId,
                  postName: postMap!["title"],
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20, bottom: 16, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${senderMap!["nick-name"]}님의 신청",
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 20,
                        height: 0.8,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      postMap!["title"],
                      style: TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 15,
                        height: 0.8,
                        color: Color(0xff888888),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${DateFormat('M/dd, ${ampm}h시').format((postMap!["time"] as Timestamp).toDate())}",
                      style: TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 15,
                        height: 0.8,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                )),
            check
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        decoration: new BoxDecoration(
                          color: Colors.orangeAccent[100],
                          shape: BoxShape.circle,
                        ),
                        height: 10,
                        width: 10),
                  )
          ],
        ),
      ),
    );
  }
}

class PostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserData>(context).userId;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy("time", descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff27AC84),
            ),
          );
        }
        if (snapshot.data!.size == 0) {
          print("hi");
          return Center(child: Text("신청이 아직 없습니다"));
        }

        final requests = snapshot.data!.docs;
        List<Widget> requestBubbles = [];
        for (var request in requests) {
          String ampm;
          DateFormat('a').format(
                      (request["post-map"]["time"] as Timestamp).toDate()) ==
                  "AM"
              ? ampm = "오전"
              : ampm = "오후";
          final requestBubble = RequestBubble(
            ampm: ampm,
            introduce: request["introduce"],
            senderMap: request["sender-map"],
            postMap: request["post-map"],
            senderId: request["sender-id"],
            check: request["check"],
            requestId: request.id,
          );
          requestBubbles.add(requestBubble);
        }

        if (requestBubbles == []) {
          return Center(child: Text("신청이 아직 없습니다"));
        }
        return ListView(
          children: requestBubbles,
        );
      },
    );
  }
}

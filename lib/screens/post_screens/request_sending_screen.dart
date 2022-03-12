import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';

final _firestore = FirebaseFirestore.instance;

class RequestSendingScreen extends StatefulWidget {
  RequestSendingScreen(
      {required this.postId, required this.recieverId, required this.postType});
  String postId;
  String recieverId;
  String postType;
  @override
  _RequestSendingScreenState createState() => _RequestSendingScreenState();
}

class _RequestSendingScreenState extends State<RequestSendingScreen> {
  String? introduceForSending;
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              TextFormField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      introduceForSending = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  maxLength: 100,
                  maxLines: 10,
                  textInputAction:
                      TextInputAction.done, // maxline 적용시 키보드에 완료키 사라지는 문제 해결
                  decoration: InputDecoration(
                    hintText: '짧은 소개 (필수 아님)',
                    hintStyle: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.8, color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.2, color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              RoundedButton(
                  colour: Color(0xff27ac84),
                  title: "신청하기",
                  onPressed: () async {
                    String senderId =
                        Provider.of<UserData>(context, listen: false).userId;
                    Map<String, dynamic>? userMap;
                    Map<String, dynamic>? postMap;
                    //TODO: 거주지 추가하면, request로 거주지는 보내주면 안된다 userMap.remove거주지필드
                    await _firestore
                        .collection("users")
                        .doc(senderId)
                        .get()
                        .then((val) {
                      userMap = val.data();
                    });
                    await _firestore
                        .collection(widget.postType)
                        .doc(widget.postId)
                        .get()
                        .then((val) {
                      postMap = val.data();
                    });

                    //sender userid, introduceForSending을 reciever user doc의 notification collection에 저장
                    await _firestore
                        .collection("users")
                        .doc(widget.recieverId)
                        .collection("notifications")
                        .add({
                      "sender-map": userMap,
                      "introduce": introduceForSending,
                      "post-map": postMap,
                      "time": DateTime.now(),
                      "sender-id": senderId,
                      "receiver-id": widget.recieverId,
                      "check": false,
                    }).then((val) async {
                      await _firestore
                          .collection("users")
                          .doc(widget.recieverId)
                          .update({"notification-check": false});
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("신청이 완료되었습니다"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [Text('상대방 수락 시 채팅방이 생깁니다')],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      int count = 0;
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    },
                                    child: Text("예")),
                              ],
                            );
                          });
                    }).onError((error, stackTrace) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("신청이 되지 않습니다. 재시도 해주세요."),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("예")),
                              ],
                            );
                          });
                    });
                    // 신청이 잘못되었거나, 잘되었으면 팝업창으로 알려주기
                    // navigator pop
                  })
            ],
          ),
        ));
  }
}

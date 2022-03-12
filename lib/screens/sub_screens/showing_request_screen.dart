import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/screens/basic_screen.dart';
import 'package:tennis_friends_demo/screens/chat_room_screen.dart';

final _firestore = FirebaseFirestore.instance;

class ShowingRequestScreen extends StatefulWidget {
  static String id = 'showing_request_screen';

  ShowingRequestScreen(
      {required this.senderId,
      required this.userMap,
      required this.introduce,
      required this.postName});

  String senderId;
  Map? userMap;
  String introduce;
  String postName;

  @override
  _ShowingRequestScreenState createState() => _ShowingRequestScreenState();
}

class _ShowingRequestScreenState extends State<ShowingRequestScreen> {
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
                    SizedBox(
                      height: 15,
                    ),
                    ConditionalShortIntroduce(widget.introduce),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RoundedButton(
                colour: Color(0xff27AC84),
                onPressed: () async {
                  //createChatRoom();
                  final receiver =
                      Provider.of<UserData>(context, listen: false).nickName!;
                  String chatRoomId = await createChatRoom(
                      sender: widget.userMap!["nick-name"], receiver: receiver);
                  await _firestore
                      .collection("users")
                      .doc(Provider.of<UserData>(context, listen: false).userId)
                      .collection("rooms")
                      .doc(chatRoomId)
                      .set({
                    "room-id": chatRoomId,
                    "friend-name": widget.userMap!["nick-name"],
                    "sender-id": widget.senderId,
                    "receiver-id":
                        Provider.of<UserData>(context, listen: false).userId,
                  });
                  try {
                    await _firestore
                        .collection("users")
                        .doc(widget.senderId)
                        .collection("rooms")
                        .doc(chatRoomId)
                        .set({
                      "room-id": chatRoomId,
                      "friend-name": receiver,
                      "sender-id": widget.senderId,
                      "receiver-id":
                          Provider.of<UserData>(context, listen: false).userId,
                    });
                    //navigate to ChatScreen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatRoomScreen(
                        roomId: chatRoomId,
                        senderId: widget.senderId,
                        receiverId:
                            Provider.of<UserData>(context, listen: false)
                                .userId,
                        friendName: widget.userMap!["nick-name"],
                      );
                    }));
                  } catch (e) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("신청 유저를 찾을 수 없습니다"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("확인")),
                            ],
                          );
                        });
                  }
                },
                title: "채팅 시작하기",
              ),
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

Widget ConditionalShortIntroduce(String? introduce) {
  if (introduce == null) return SizedBox.shrink();
  return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        "${introduce}",
        style: TextStyle(fontSize: 18),
      ));
}

Future<String> createChatRoom(
    {required String sender, required String receiver}) async {
  DocumentReference chatRoomId = await _firestore.collection("chat-rooms").add({
    "request-receiver": receiver,
    "request-sender": sender,
  });
  return chatRoomId.id;
}

import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance; //firestore instance
late User loggedInUser; // prepare to receive loggedinuser

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen(
      {required this.roomId,
      required this.senderId,
      required this.receiverId,
      required this.friendName});
  //String postName;
  String roomId;
  String senderId;
  String receiverId;
  String friendName;
  static String id = 'chat_room_screen';

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final messageTextController =
      TextEditingController(); //prepare to controll textfield
  final _auth = FirebaseAuth.instance; // firebase authentication instance

  late String messageText; // prepare to receive chat

  @override
  void initState() {
    super.initState();

    getCurrentUser(); //get loggedinuser
    setWatched();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void setWatched() async {
    await _firestore
        .collection("users")
        .doc(Provider.of<UserData>(context, listen: false).userId)
        .collection("rooms")
        .doc(widget.roomId)
        .update({"last-watched": true});
    print("hi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.black12,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(0.0)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.friendName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              roomId: widget.roomId,
            ), // 채팅 기록 띄움 (파이어스토어 스트림 이용)
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController, //텍스트 필드 컨트롤러 등록
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Implement send functionality.
                      messageTextController.clear(); // 전송한 채팅은 입력기에서 사라져야 하기 때문

                      final message = {
                        //message라는 콜렉션에 채팅 기록 저장
                        "sender": Provider.of<UserData>(context, listen: false)
                            .nickName, // sender 정보 파이어스토어에 저장
                        "text": messageText, //입력한 메시지 파이어스토어에 저장
                        "timestamp": Timestamp.now(), // 시간순으로 출력하기 위함
                      };

                      await _firestore
                          .collection("chat-rooms")
                          .doc(widget.roomId)
                          .collection("messages")
                          .add(message);
                      await _firestore
                          .collection("users")
                          .doc(widget.senderId)
                          .collection("rooms")
                          .doc(widget.roomId)
                          .update({
                        "last-sender": message["sender"],
                        "last-text": message["text"],
                        "last-timestamp": message["timestamp"],
                        "last-watched": widget.senderId == loggedInUser.uid
                      });
                      await _firestore
                          .collection("users")
                          .doc(widget.receiverId)
                          .collection("rooms")
                          .doc(widget.roomId)
                          .update({
                        "last-sender": message["sender"],
                        "last-text": message["text"],
                        "last-timestamp": message["timestamp"],
                        "last-watched": widget.receiverId == loggedInUser.uid
                      });
                    },
                    child: Text(
                      '전송',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({
    required this.roomId,
  });
  String roomId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("chat-rooms")
            .doc(roomId)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            final messageSender = message['sender'];
            final messageText = message['text'];

            final currentUser =
                Provider.of<UserData>(context, listen: false).nickName;
            final bool isMe = messageSender == currentUser;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: isMe,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                reverse: true,
                children: messageBubbles,
              ),
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
            color: isMe ? Color(0xef1ece71) : Colors.grey[300],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

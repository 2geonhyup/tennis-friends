import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_room_screen.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ChatsStream();
  }
}
//chat room screen과 연결해줘야함

class ChatsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("users")
            .doc(Provider.of<UserData>(context).userId)
            .collection("rooms")
            .orderBy("last-timestamp")
            .limit(100)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff27AC84),
              ),
            );
          }
          final chatRooms = snapshot.data!.docs;
          List<Widget> roomBubbles = [];
          for (var room in chatRooms) {
            final roomBubble = RoomBubble(room: room);
            roomBubbles.add(roomBubble);
          }
          return ListView(children: roomBubbles);
        });
  }
}

class RoomBubble extends StatelessWidget {
  RoomBubble({required this.room});
  QueryDocumentSnapshot room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(
                        roomId: room["room-id"],
                        senderId: room["sender-id"],
                        receiverId: room["receiver-id"],
                        friendName: room["friend-name"],
                      )));
        },
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.black.withOpacity(0.05), width: 1.2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room["friend-name"],
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 18,
                        height: 0.8,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        room["last-text"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'SairaCondensed',
                          color: Colors.black26,
                          fontSize: 15,
                          height: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              room["last-watched"]
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
        ));
  }
}

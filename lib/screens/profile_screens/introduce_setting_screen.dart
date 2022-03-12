import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';

final _firestore = FirebaseFirestore.instance;

class IntroduceSettingScreen extends StatefulWidget {
  @override
  State<IntroduceSettingScreen> createState() => _IntroduceSettingScreenState();
}

class _IntroduceSettingScreenState extends State<IntroduceSettingScreen> {
  final _auth = FirebaseAuth.instance;
  String? introduce;
  String? oldIntroduce;

  @override
  Widget build(BuildContext context) {
    oldIntroduce = Provider.of<UserData>(context).introduce;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("소개 추가"),
        centerTitle: true,
        leading: TextButton(
          child: Text(
            "취소",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "완료",
            ),
            onPressed: () {
              if (introduce != null) {
                if (introduce == "") {
                  introduce = null;
                }
                Provider.of<UserData>(context, listen: false)
                    .registerIntroduce(introduce);
                final userUid = _auth.currentUser?.uid;
                _firestore
                    .collection("users")
                    .doc(userUid)
                    .update({"introduce": introduce});
              }

              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "테니스 치는 곳, 실력 등",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            Text(
              "자신을 자유롭게 소개해주세요!",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                initialValue: Provider.of<UserData>(context).introduce,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    introduce = value;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLength: 40,
                maxLines: 2,
                textInputAction:
                    TextInputAction.done, // maxline 적용시 키보드에 완료키 사라지는 문제 해결
                decoration: InputDecoration(
                  hintText: '자기소개 추가하기 (최대 20자)',
                  hintStyle: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

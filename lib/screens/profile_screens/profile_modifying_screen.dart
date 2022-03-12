import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/components/profile_setting_container.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class ProfileModifyingScreen extends StatelessWidget {
  static String id = "profile_setting_screen";

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
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
          title: Text(
            "프로필 편집",
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ListView(children: [
              SizedBox(
                height: 40,
              ),
              profileSettingContainer(
                  hint: "성별",
                  value: Provider.of<UserData>(context).gender,
                  valueList: kGenderList,
                  onChanged: (val) {
                    Provider.of<UserData>(context, listen: false)
                        .registerGender(val.toString());
                  }),
              SizedBox(
                height: 20,
              ),
              profileSettingContainer(
                  hint: "나이",
                  value: Provider.of<UserData>(context).age,
                  valueList: kAgeList,
                  onChanged: (val) {
                    Provider.of<UserData>(context, listen: false)
                        .registerAge(val.toString());
                  }),
              SizedBox(
                height: 20,
              ),
              profileSettingContainer(
                  hint: "구력",
                  value: Provider.of<UserData>(context).tennisAge,
                  valueList: kTennisAgeList,
                  onChanged: (val) {
                    Provider.of<UserData>(context, listen: false)
                        .registerTennisAge(val.toString());
                  }),
              SizedBox(
                height: 20,
              ),
              RoundedButton(
                colour: Provider.of<UserData>(context, listen: false).allFilled
                    ? Color(0xff27AC84)
                    : Colors.black45,
                title: '프로필 수정하기',
                onPressed: () {
                  if (Provider.of<UserData>(context, listen: false).allFilled ==
                      false) return;
                  final userUid = _auth.currentUser?.uid;
                  _firestore.collection("users").doc(userUid).update(
                      Provider.of<UserData>(context, listen: false)
                          .getUserInfo);
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/screens/sub_screens/user_posts_screen.dart';
import 'register_login_screens/start_screen.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import 'profile_screens/profile_modifying_screen.dart';
import 'profile_screens/introduce_setting_screen.dart';
import 'profile_screens/user_location_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tennis_friends_demo/services/networking.dart';
import 'package:tennis_friends_demo/functions.dart';

final _auth = FirebaseAuth.instance;

class ProfileScreen extends StatelessWidget {
  static String id = "profile_screen";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10,
        ),
        ProfileView(),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SubProfile(
                        //TODO: 거주지 추가 화면
                        icon: Provider.of<UserData>(context).location == null
                            ? Icon(
                                Icons.my_location_outlined,
                                color: Colors.black54,
                                size: 25,
                              )
                            : Column(
                                children: [
                                  Icon(
                                    Icons.autorenew,
                                    color: Colors.black54,
                                    size: 22,
                                  ),
                                  Text(
                                    "재설정",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                        text:
                            Provider.of<UserData>(context).locationName == null
                                ? "터치해서 현재 위치로 거주지 설정"
                                : Provider.of<UserData>(context).locationName!,
                        onTap: () async {
                          // 현재 위치로 거주지 설정
                          //TODO: location permission 확인
                          await setLocationMethod(context);
                        },
                      ),
                      SubProfile(
                        icon: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    width: 1.2, color: Colors.black54)),
                            child: Icon(
                              Icons.add,
                              color: Colors.black54,
                              size: 18,
                            )),
                        //TODOcomp: 소개 추가 화면으로 navigate (글자 수 30자 제한)
                        text: Provider.of<UserData>(context).introduce ??
                            "터치해서 짧은 소개 추가하기",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IntroduceSettingScreen()));
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileModifyingScreen()));
                            },
                            child: Text(
                              "프로필 편집",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            )),
                        height: 40,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.2, color: Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserPostsScreen(
                                        uid: Provider.of<UserData>(context).userId,
                                        name: Provider.of<UserData>(context).nickName!,
                                      )));
                            },
                            child: Text(
                              "내가 쓴 글",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            )),
                        height: 40,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.2, color: Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      )
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.popAndPushNamed(context, StartScreen.id);
                    },
                    child: Text("로그아웃"))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubProfile extends StatelessWidget {
  SubProfile({required this.text, required this.icon, required this.onTap});

  String text;
  Widget icon;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 15),
              ),
            ),
            icon
          ],
        ),
      ),
    );
  }
}

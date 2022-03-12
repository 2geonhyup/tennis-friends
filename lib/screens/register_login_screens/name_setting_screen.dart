import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/constants.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/verify_screen.dart';
import 'package:tennis_friends_demo/functions.dart';

class NameSettingScreen extends StatefulWidget {
  static String id = "name_setting_screen";

  @override
  State<NameSettingScreen> createState() => _NameSettingScreenState();
}

class _NameSettingScreenState extends State<NameSettingScreen> {
  String name = "";

  String nameCheck = "";

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
              ),
              Hero(
                tag: 'text',
                child: Text(
                  "한국어 닉네임을 설정해주세요",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 15),
                  child: Text(
                    nameCheck,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 13, color: Colors.pinkAccent),
                  ),
                ),
              ),
              TextField(
                  //textAlign: TextAlign.center,
                  obscureText: false,
                  onChanged: (value) async {
                    nameCheck = await checkNickName(value);
                    //TODOcomp: 닉네임 중복 검사해야함
                    //TODOcomp: 닉네임 형식(한글)에 맞게 입력한 경우만 넘어가게 해야함(정규식과 TextFormFeild 활용)
                    setState(() {
                      name = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: kTextFieldDecoration.copyWith(hintText: '닉네임')),
              RoundedButton(
                colour: nameCheck != "가능한 닉네임입니다!"
                    ? Colors.black45
                    : Color(0xef27AC84),
                title: '닉네임 설정하기',
                onPressed: () {
                  if (nameCheck != "가능한 닉네임입니다!") return;
                  Provider.of<UserData>(context, listen: false)
                      .registerUser(name);
                  Navigator.pushNamed(context, VerifyScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

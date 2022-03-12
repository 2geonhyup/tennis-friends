import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/login_screen.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/profile_setting_screen.dart';
import 'location_setting_screen.dart';

class StartScreen extends StatelessWidget {
  static String id = 'start_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Tennis Friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff27AC84)),
                  ),
                  const Text(
                    "테니스 친구를 찾아봐요!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundedButton(
                  colour: Color(0xff27AC84),
                  title: '시작하기',
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileSettingScreen.id);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "이미 계정이 있나요? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                        //TODO: 화면 아래기준으로 버튼 만들기
                        const Text(
                          " 로그인",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff27AC84)),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tennis_friends_demo/screens/post_screens/court_creating_screen.dart';
import 'package:tennis_friends_demo/screens/post_screens/court_modifying_screen.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/login_screen.dart';
import 'screens/register_login_screens/start_screen.dart';
import 'screens/register_login_screens/profile_setting_screen.dart';
import 'screens/register_login_screens/name_setting_screen.dart';
import 'screens/basic_screen.dart';
import 'models/user_data.dart';
import 'screens/register_login_screens/verify_screen.dart';
import 'functions.dart';
import 'package:flutter/services.dart';
import 'screens/post_screens/post_creating_screen.dart';
import 'screens/post_screens/user_post_view.dart';
import 'screens/post_screens/post_modifying_screen.dart';
import 'screens/post_screens/post_view_screen.dart';
import 'screens/profile_screens/showing_profile_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/register_login_screens/location_setting_screen.dart';
import 'screens/sub_screens/user_posts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  bool loggedIn = await userExist();
  runApp(TennisFriends(loggedIn: loggedIn));
}

class TennisFriends extends StatelessWidget {
  TennisFriends({required this.loggedIn});
  bool loggedIn;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //TODOcomp: 로그인이 되어있는 경우 바로 홈화면으로 가야 한다.
      create: (context) => UserData(),
      child: MaterialApp(
        initialRoute: loggedIn ? BasicScreen.id : StartScreen.id,
        routes: {
          BasicScreen.id: (context) => BasicScreen(),
          StartScreen.id: (context) => StartScreen(),
          ProfileSettingScreen.id: (context) => ProfileSettingScreen(),
          NameSettingScreen.id: (context) => NameSettingScreen(),
          VerifyScreen.id: (context) => VerifyScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          PostCreatingScreen.id: (context) => PostCreatingScreen(),
          UserPostView.id: (context) => UserPostView(),
          PostModifyingScreen.id: (context) => PostModifyingScreen(),
          CourtModifyingScreen.id: (context) => CourtModifyingScreen(),
          CourtCreatingScreen.id: (context) => CourtCreatingScreen(),
          LocationSettingScreen.id: (context) => LocationSettingScreen(),
        },
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

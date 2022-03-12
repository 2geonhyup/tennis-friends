import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/screens/home_screen.dart';
import 'profile_screen.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'court_pass_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'post_screens/post_creating_screen.dart';
import 'post_screens/court_creating_screen.dart';
import 'sub_screens/notification_screen.dart';
import 'package:tennis_friends_demo/functions.dart';

final _firestore = FirebaseFirestore.instance;

class BasicScreen extends StatefulWidget {
  static String id = "basic_screen";
  @override
  _BasicScreenState createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  final _auth = FirebaseAuth.instance;

  int _pageIndex = 0;
  late PageController _pageController;
  String userNickName = "";
  bool _visible = true;

  List<Widget> tabPages = [
    HomeScreen(),
    CourtPassScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  List<String> pagesTitle = ["Tennis Friends", "코트양도", "채팅", "프로필"];

  void getCurrentUserData() async {
    final userUid = _auth.currentUser?.uid;
    final getUserInfo = await _firestore.collection("users").doc(userUid).get();
    final storedUserInfo = getUserInfo.data()!;

    Provider.of<UserData>(context, listen: false).setUserInfo(
        nickName: storedUserInfo["nick-name"],
        gender: storedUserInfo["gender"],
        age: storedUserInfo["age"],
        tennisAge: storedUserInfo["tennis-age"],
        introduce: storedUserInfo["introduce"],
        location: storedUserInfo["location"],
        locationName: storedUserInfo["location-name"]);
    if (Provider.of<UserData>(context, listen: false).location == null) {
      print("hi");
      setLocationMethod(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    getCurrentUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    String title = Provider.of<UserData>(context).locationName == null
        ? "위치 모름"
        : Provider.of<UserData>(context)
            .locationName!
            .split(' ')
            .sublist(2, 3)
            .join(' ');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        bottom: PreferredSize(
            child: _pageIndex == 0
                ? SizedBox.shrink()
                : Container(
                    color: Colors.white,
                    height: 0.8,
                  ),
            preferredSize: Size.fromHeight(0.0)),
        leadingWidth: 0,
        titleSpacing: 20,
        title: Text(
          _pageIndex == 0 ? title : pagesTitle[_pageIndex],
          style: TextStyle(
              fontFamily: 'SairaCondensed',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 24),
        ),
        // : Text(
        //     pagesTitle[_pageIndex],
        //     style: TextStyle(
        //         fontFamily: 'SairaCondensed',
        //         fontWeight: FontWeight.w700,
        //         color: Color(0xff27AC84),
        //         fontSize: 28),
        //   ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              width: 30,
              height: 24,
              child: Stack(children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.black54,
                    size: 24,
                  ),
                  onPressed: () async {
                    await _firestore
                        .collection("users")
                        .doc(Provider.of<UserData>(context, listen: false)
                            .userId)
                        .update({"notification-check": true});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                ),
                StreamBuilder(
                    stream: _firestore
                        .collection('users')
                        .doc(Provider.of<UserData>(context).userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final tmp = snapshot.data as DocumentSnapshot;
                        late bool note;
                        tmp["notification-check"] == null
                            ? note = true
                            : note = tmp["notification-check"];
                        return !note
                            ? Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orangeAccent,
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                ),
                              )
                            : Container();
                      }
                      return Container();
                    }),
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: Colors.black.withOpacity(0.1), width: 1))),
        height: 60,
        child: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: onTabTapped,
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 26,
              ),
              activeIcon: Icon(
                Icons.home,
                size: 26,
              ),
              label: '모임',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sports_tennis_outlined,
                size: 26,
              ),
              activeIcon: Icon(
                Icons.sports_tennis,
                size: 26,
              ),
              label: '코트양도',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer_outlined,
                size: 26,
              ),
              activeIcon: Icon(
                Icons.question_answer,
                size: 26,
              ),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
                size: 26,
              ),
              activeIcon: Icon(
                Icons.person,
                size: 26,
              ),
              label: '프로필',
            ),
          ],
          selectedItemColor: Color(0xff27AC84),
          unselectedItemColor: Colors.black54,
          unselectedFontSize: 12,
          selectedFontSize: 12,
        ),
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: SpeedDial(
          spacing: 20,
          closeDialOnPop: true,
          closeManually: false,
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Color(0xff27AC84),
          activeBackgroundColor: Colors.black26,
          elevation: 0,
          renderOverlay: true,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          spaceBetweenChildren: 10,
          childrenButtonSize: Size(70, 70),
          children: [
            SpeedDialChild(
                elevation: 0,
                child: Icon(
                  Icons.create,
                  color: Colors.white,
                  size: 30,
                ),
                label: '테친 모집하기',
                backgroundColor: Color(0xff27ac84),
                onTap: () {
                  if (Provider.of<UserData>(context, listen: false).location ==
                      null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("프로필 화면에서 위치를 설정해야 글을 작성할 수 있습니다"),
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
                    return;
                  }
                  Navigator.pushNamed(context, PostCreatingScreen.id);
                }),
            SpeedDialChild(
                elevation: 0,
                child: ImageIcon(
                  AssetImage("images/tennis-court.png"),
                  size: 30,
                ),
                label: '코트 양도하기',
                onTap: () {
                  if (Provider.of<UserData>(context, listen: false).location ==
                      null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("프로필 화면에서 위치를 설정해야 글을 작성할 수 있습니다"),
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
                    return;
                  }
                  Navigator.pushNamed(context, CourtCreatingScreen.id);
                }),
          ],
        ),
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      if (page == 2 || page == 3)
        _visible = false;
      else
        _visible = true;
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.jumpToPage(index);
  }
}

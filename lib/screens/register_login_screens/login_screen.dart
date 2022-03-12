import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_friends_demo/constants.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/screens/register_login_screens/profile_setting_screen.dart';
import '../basic_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String number = "";
  bool numValid = false;
  String numValidString = "";
  late String verificationId;
  String smsCode = "";
  User? user;
  String? userUid;

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    // myFocusNode에 포커스 인스턴스 저장.
    myFocusNode = FocusNode();
  }

  // 폼이 삭제될 때 호출
  @override
  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    myFocusNode.dispose();
    super.dispose();
  }

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
        title: Text(
          "번호로 로그인",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 15),
                child: Text(
                  numValidString,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 13, color: Colors.pinkAccent),
                ),
              ),
            ),
            TextField(
              //textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLength: 11,
              autofocus: true,
              onChanged: (value) {
                //TODOcomp: 번호 길이 검사해서  11자리 찼을 경우만 전송버튼 누르도록 하기
                number = value;
                setState(() {
                  number = value;
                  numValid = number.length == 11;
                  if (numValidString != "") numValidString = "";
                });
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: kTextFieldDecoration.copyWith(
                  hintText: '띄어쓰기 없이 번호 입력  ex) 01011112222',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  counterText: ""),
            ),
            RoundedButton(
              //TODO: 번호로 문자가 제대로 간 경우, 재전송 대기시간까지는 해당 버튼이 비활성화 되어야 한다.(텍스트 필드 바뀌면 다시 활성화)
              colour: numValid ? Color(0xff27AC84) : Colors.black45,
              onPressed: () async {
                if (numValid == false) {
                  setState(() {
                    numValidString = "띄어쓰기 없이 11자리를 입력해주세요.";
                  });
                  return;
                }
                int? _resendToken;
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+82' + number.substring(1),
                  verificationCompleted: (PhoneAuthCredential credential) {
                    // await _auth.signInWithCredential(credential);
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    if (e.code == 'invalid-phone-number') {
                      //TODOcomp: 화면에 번호없다고 뜨도록 설정
                      String error = e.code == 'invalid-phone-number'
                          ? "유효하지 않은 번호입니다. 다시시도해 주세요"
                          : "죄송합니다 지금 로그인 할 수 없습니다.";
                      numValidString = error;
                      setState(() {});
                    }
                  },
                  codeSent: (String verificationId, int? resendToken) async {
                    this.verificationId = verificationId;
                    _resendToken = resendToken;
                    FocusScope.of(context).requestFocus(myFocusNode);
                    setState(() {});
                  },
                  timeout: const Duration(seconds: 5),
                  codeAutoRetrievalTimeout: (String verificationId) {},
                  forceResendingToken: _resendToken,
                );
              },
              title: "인증문자 받기",
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                //textAlign: TextAlign.center,
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                obscureText: false,
                onChanged: (value) {
                  setState(() {
                    smsCode = value;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                //TODO: 코드 입력 대기시간 알려줌
                decoration: kTextFieldDecoration.copyWith(hintText: '코드')),
            RoundedButton(
                onPressed: () async {
                  //TODO: 코드 잘 못입력한 경우 화면에서 알려줘야 함
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: smsCode);
                  final loggedInUser =
                      await _auth.signInWithCredential(phoneAuthCredential);

                  // document id = user uid
                  final user = _auth.currentUser;

                  if (loggedInUser.additionalUserInfo!.isNewUser) {
                    await user?.delete();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("없는 계정입니다"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [Text('가입을 시작해주세요')],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProfileSettingScreen.id);
                                  },
                                  child: Text("예")),
                            ],
                          );
                        });
                  } else {
                    // 이미 있는 계정의 경우
                    Navigator.pushNamed(context, BasicScreen.id);
                  }
                },
                colour: smsCode != "" ? Color(0xff27AC84) : Colors.black45,
                title: "바로 시작하기")
          ],
        ),
      ),
    );
  }
}

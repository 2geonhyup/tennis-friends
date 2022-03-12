import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';
import 'user_post_view.dart';
import 'package:tennis_friends_demo/components/text_input_container.dart';

class CourtCreatingScreen extends StatefulWidget {
  static String id = "court_creating_screen";

  @override
  _CourtCreatingScreenState createState() => _CourtCreatingScreenState();
}

class _CourtCreatingScreenState extends State<CourtCreatingScreen> {
  var post;
  String? title;
  DateTime? time;
  String? place;
  String? courtFee;
  String? additionalInfo;
  String? matchTime;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.black12,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(0.0)),
        title: Text("게시물 작성"),
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
        actions: [
          TextButton(
              onPressed: () async {
                title == "" ? title = null : null;
                place == "" ? place = null : null;
                courtFee == "" ? courtFee = null : null;
                additionalInfo == "" ? additionalInfo = null : null;
                matchTime == "" ? matchTime = null : null;

                final List unready =
                    Provider.of<UserData>(context, listen: false)
                        .postFieldCheck(
                            postType: 2,
                            title: title,
                            time: time,
                            place: place,
                            courtFee: courtFee,
                            matchTime: matchTime);
                if (unready.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("${unready.join(", ")} 항목은 필수로 입력해야 해요"),
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
                final postId =
                    await Provider.of<UserData>(context, listen: false).addPost(
                  title: title!,
                  time: time!,
                  place: place!,
                  courtFee: courtFee!,
                  additionalInfo: additionalInfo,
                  timeStamp: now,
                  matchTime: matchTime!,
                  postType: "courts",
                );
                if (postId != null) {
                  print(postId);
                  Navigator.popAndPushNamed(context, UserPostView.id,
                      arguments: {"postId": postId, "postType": "courts"});
                } else {
                  print("postId is null");
                  return;
                }
              },
              child: Text("완료"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  TextInputContainer(
                    hint: "테니스장 이름 (최대 15자)",
                    maxLength: 15,
                    onChanged: (val) {
                      setState(() {
                        title = val;
                      });
                    },
                  ),

                  TextInputContainer(
                    hint: "지역 및 위치",
                    inputAction: TextInputAction.done,
                    onChanged: (val) {
                      setState(() {
                        place = val;
                      });
                    },
                  ),
                  //TODOcomp: 시간 추가
                  Container(
                    height: 65,
                    padding: EdgeInsets.only(left: 13.5, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        //bottom: BorderSide(color: Colors.black12)
                      ),
                    ),
                    child: TextButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: now,
                              maxTime: now.add(const Duration(days: 365)),
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              time = date;
                            });
                            print(
                                "${date.year}/${date.month}/${date.day} ${date.hour}시${date.minute}분 ");
                          }, currentTime: time ?? now, locale: LocaleType.ko);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              time == null
                                  ? '시작 시간 선택하기'
                                  : "${time!.year}년 ${time!.month}월 ${time!.day}일  ${time!.hour}시${time!.minute}분 ",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.expand_more,
                              size: 30,
                              color: Colors.black45,
                            )
                          ],
                        )),
                  ),
                  TextInputContainer(
                    hint: "예약 시간 (총 몇시간 예약했는지 적어주세요)",
                    onChanged: (val) {
                      setState(() {
                        matchTime = val;
                      });
                    },
                  ),
                  TextInputContainer(
                    hint: "코트비",
                    onChanged: (val) {
                      setState(() {
                        courtFee = val;
                      });
                    },
                  ),

                  TextInputContainer(
                    hint: "추가 설명",
                    maxLines: 4,
                    inputAction: TextInputAction.done,
                    bottomBorder: false,
                    maxLength: 80,
                    onChanged: (val) {
                      setState(() {
                        additionalInfo = val;
                      });
                    },
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';
import 'user_post_view.dart';
import 'package:tennis_friends_demo/components/text_input_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class PostModifyingScreen extends StatefulWidget {
  static String id = "post_modifying_screen.dart";
  final String? postId;
  const PostModifyingScreen({Key? key, this.postId}) : super(key: key);
  @override
  _PostModifyingScreenState createState() => _PostModifyingScreenState();
}

class _PostModifyingScreenState extends State<PostModifyingScreen> {
  Future<void> getCurrentPost() async {
    final doc = await _firestore.collection("posts").doc(widget.postId).get();
    final data = doc.data();
    title = data!["title"];
    place = data["place"];
    courtFee = data["court-fee"];
    member = data["member"];
    memberRequirement = data["member-requirement"];
    additionalInfo = data['additional-info'];
    time = (data["time"] as Timestamp).toDate();
    matchTime = data['match-time'];
  }

  String? title;
  DateTime? time;
  String? place;
  String? courtFee;
  String? member;
  String? memberRequirement;
  String? additionalInfo;
  String? matchTime;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return FutureBuilder(
        future: Future.wait([getCurrentPost()]),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (!snapshot.hasData) {
            // Future not done, return a temporary loading widget
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.black12,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(0.0)),
              title: Text("게시물 수정"),
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
                      member == "" ? member = null : null;
                      memberRequirement == "" ? memberRequirement = null : null;
                      additionalInfo == "" ? additionalInfo = null : null;
                      matchTime == "" ? matchTime = null : null;

                      final List unready =
                          Provider.of<UserData>(context, listen: false)
                              .postFieldCheck(
                                  postType: 1,
                                  title: title,
                                  time: time,
                                  place: place,
                                  courtFee: courtFee,
                                  member: member,
                                  matchTime: matchTime);
                      if (unready.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text(
                                          "${unready.join(", ")} 항목은 필수로 입력해야 해요"),
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
                      await Provider.of<UserData>(context, listen: false)
                          .updatePost(
                              title: title!,
                              time: time!,
                              place: place!,
                              courtFee: courtFee!,
                              member: member!,
                              memberRequirement: memberRequirement,
                              additionalInfo: additionalInfo,
                              timeStamp: now,
                              postId: widget.postId!,
                              matchTime: matchTime!,
                              postType: "posts");

                      Navigator.popAndPushNamed(context, UserPostView.id,
                          arguments: {
                            "postId": widget.postId,
                            "postType": "posts"
                          });
                    },
                    child: Text("수정"))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  TextInputContainer(
                    hint: "테니스장 이름 (최대 15자)",
                    value: title,
                    maxLines: 2,
                    maxLength: 15,
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextInputContainer(
                    hint: "지역 및 위치",
                    value: place,
                    onChanged: (val) {
                      place = val;
                    },
                  ),
                  //TODOcomp: 시간 추가
                  StatefulBuilder(builder: (_context, _setState) {
                    return Container(
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
                              _setState(() {
                                time = date;
                              });
                            }, currentTime: time ?? now, locale: LocaleType.ko);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                time == null
                                    ? '시작시간 선택하기'
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
                    );
                  }),

                  TextInputContainer(
                    hint: "진행시간 (예시: 두시간)",
                    value: matchTime,
                    onChanged: (val) {
                      matchTime = val;
                    },
                  ),
                  TextInputContainer(
                    hint: "코트비",
                    value: courtFee,
                    onChanged: (val) {
                      courtFee = val;
                    },
                  ),
                  TextInputContainer(
                    hint: "모집 인원 (예시: 여1 남2 구해요!)",
                    value: member,
                    onChanged: (val) {
                      member = val;
                    },
                  ),
                  TextInputContainer(
                    hint: "모집 대상 (연령대, 구력, 실력 등등)",
                    value: memberRequirement,
                    maxLines: 4,
                    onChanged: (val) {
                      memberRequirement = val;
                    },
                  ),

                  TextInputContainer(
                    inputAction: TextInputAction.done,
                    hint: "추가 설명",
                    value: additionalInfo,
                    maxLines: 4,
                    maxLength: 80,
                    onChanged: (val) {
                      additionalInfo = val;
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

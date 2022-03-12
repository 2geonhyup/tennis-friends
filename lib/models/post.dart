import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.title,
      required this.place,
      required this.time,
      required this.member,
      required this.courtFee,
      this.memberRequirement,
      this.additionalInfo,
      required this.timeStamp,
      required this.postId});

  String title;
  String place;
  Timestamp time;
  String member;
  String courtFee;
  String? memberRequirement;
  String? additionalInfo;
  Timestamp timeStamp;
  String postId;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

final _firestore = FirebaseFirestore.instance;

class UserData extends ChangeNotifier {
  String? nickName;
  String? gender;
  String? age;
  String? tennisAge;
  String? introduce;
  Map<String, dynamic>? location;
  String? locationName;
  List<String> _userPostIds = [];
  String? currentPostId;
  String? menu;

  late thisUser user;

  String get userId {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      print(user.uid);
      return user.uid;
    }
    return "user doesn't exist";
  }

  void registerMenu(menu) {
    this.menu = menu;
    notifyListeners();
  }

  Future<void> setLocation(
      {Map<String, double>? location, String? locationName}) async {
    if (location == null || locationName == null) return;
    this.location = location;
    this.locationName = locationName;
    await _firestore
        .collection("users")
        .doc(userId)
        .update({"location": location, "location-name": locationName});
    notifyListeners();
  }

  void registerGender(gender) {
    this.gender = gender;
    notifyListeners();
  }

  void registerAge(age) {
    this.age = age;
    notifyListeners();
  }

  void registerTennisAge(tennisAge) {
    this.tennisAge = tennisAge;
    notifyListeners();
  }

  void registerIntroduce(introduce) {
    this.introduce = introduce;
    notifyListeners();
  }

  bool get allFilled {
    return gender != null && age != null && tennisAge != null;
  }

  Map<String, dynamic?> get getUserInfo {
    return {
      "nick-name": nickName,
      "gender": gender,
      "age": age,
      "tennis-age": tennisAge,
    };
  }

  void setUserInfo(
      {nickName, gender, age, tennisAge, introduce, location, locationName}) {
    this.nickName = nickName;
    this.gender = gender;
    this.age = age;
    this.tennisAge = tennisAge;
    this.introduce = introduce;
    this.location = location;
    this.locationName = locationName;
    notifyListeners();
  }

  void registerUser(nickName) {
    if (!allFilled) return;
    this.nickName = nickName;
    user = thisUser(
        nickName: nickName, gender: gender!, age: age!, tennisAge: tennisAge!);
    notifyListeners();
  }

  List<String> postFieldCheck({
    int? postType,
    String? title,
    DateTime? time,
    String? place,
    String? courtFee,
    String? member,
    String? matchTime,
  }) {
    List<String> fieldList = [];
    if (title == null) fieldList.add("테니스장");
    if (time == null) fieldList.add("시작 시간");
    if (matchTime == null) fieldList.add("진행 시간");
    if (place == null) fieldList.add("지역");
    if (courtFee == null) fieldList.add("코트비");
    if (member == null && postType == 1) fieldList.add("모집인원");

    return fieldList;
  }

  Future<String?> addPost(
      {required String title,
      required DateTime time,
      required String matchTime,
      required String place,
      required String courtFee,
      String? member,
      String? memberRequirement,
      String? additionalInfo,
      required DateTime timeStamp,
      required String postType}) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    final userUid = _auth.currentUser?.uid;
    DocumentReference docRef = await _firestore.collection(postType).add({
      "title": title,
      "time": Timestamp.fromDate(time),
      "match-time": matchTime,
      "place": place,
      "court-fee": courtFee,
      "member": member,
      "member-requirement": memberRequirement,
      "additional-info": additionalInfo,
      "time-stamp": Timestamp.fromDate(timeStamp),
      "user-uid": userUid,
      "user-location": location,
    });
    currentPostId = docRef.id;
    _userPostIds.add(currentPostId!);
    await _firestore
        .collection("users")
        .doc(userId)
        .update({"post-ids": _userPostIds});
    notifyListeners();

    return currentPostId;
  }

  Future<void> updatePost(
      {required String title,
      required DateTime time,
      required String matchTime,
      required String place,
      required String courtFee,
      String? member,
      String? memberRequirement,
      String? additionalInfo,
      required DateTime timeStamp,
      required String postId,
      required String postType}) async {
    final _auth = FirebaseAuth.instance;
    final userUid = _auth.currentUser?.uid;
    await _firestore.collection(postType).doc(postId).update({
      "title": title,
      "time": Timestamp.fromDate(time),
      "place": place,
      "court-fee": courtFee,
      "member": member,
      "member-requirement": memberRequirement,
      "additional-info": additionalInfo,
      "time-stamp": Timestamp.fromDate(timeStamp),
      "user-uid": userUid,
      "match-time": matchTime,
      "user-location": location
    });
    notifyListeners();
  }

  Future<bool> deletePost(String postId, String postType) async {
    try {
      await _firestore.collection(postType).doc(postId).delete();
      _userPostIds.remove(postId);
      await _firestore
          .collection("users")
          .doc(userId)
          .update({"post-ids": _userPostIds});
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

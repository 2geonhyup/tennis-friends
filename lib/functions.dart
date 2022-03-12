import 'package:firebase_auth/firebase_auth.dart';
import 'models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'services/networking.dart';
import 'package:provider/provider.dart';
import 'models/user_data.dart';
import 'dart:math';

// if user exist, return true
Future<bool> userExist() async {
  final _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  if (user == null) return false;
  final result =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return result.exists;
}

Future<bool> doesNameAlreadyExist(String name) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('nick-name', isEqualTo: name)
      .get();

  return result.docs.isNotEmpty;
}

Future<String> checkNickName(String nickName) async {
  String nickNamePattern = r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{1,9}$';
  RegExp nickNameRegex = RegExp(nickNamePattern);
  //name이 입력되지 않았으면, 닉네임을 입력해주세요 출력
  if (nickName.length > 9) return "닉네임은 9자리 이하입니다";
  if (nickName == "")
    return "닉네임을 입력해주세요";

  //name에 한국어, 숫자 제외한 것이 들어가면 해당 경고 출력
  else if (!nickNameRegex.hasMatch(nickName))
    return "한글과 숫자만 가능합니다";
  //name이 중복되었으면 경고 출력
  else {
    bool nameExist = await doesNameAlreadyExist(nickName);
    if (nameExist == true) return "해당 닉네임이 이미 있습니다";
  }

  //어떤 내용에도 해당되지 않으면 valid 리턴
  return "가능한 닉네임입니다!";
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<void> setLocationMethod(BuildContext context) async {
  Position position = await determinePosition().catchError((err) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("애플리케이션 설정에서 위치정보 사용을 허용해주세요."),
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
  });
  late Map<String, double> locationMap;
  locationMap = {
    "longitude": position.longitude,
    "latitude": position.latitude
  };

  late String coords;
  coords = "${position.longitude},${position.latitude}";
  String result = await NetworkHelper(
          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$coords&output=json")
      .getData();
  await Provider.of<UserData>(context, listen: false)
      .setLocation(location: locationMap, locationName: result);
}

// 2km 단위로 level 반환
int getDistanceLevel(Map point, context) {
  if (point == null) return -1;
  double lat1 = point["latitude"]!;
  double lon1 = point["longitude"]!;
  double lat2 = Provider.of<UserData>(context).location!["latitude"]!;
  double lon2 = Provider.of<UserData>(context).location!["longitude"]!;
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a))).toInt() ~/ 2;
}

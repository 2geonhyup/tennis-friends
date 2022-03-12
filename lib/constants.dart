import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(
      color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.black54),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Color(0xef27AC84)),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Color(0xef1ebe71),
  fontWeight: FontWeight.bold,
  fontSize: 17.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: '메시지 입력...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black12, width: 1.0),
  ),
);

const List<String> kGenderList = ['남자', '여자'];

const List<String> kAgeList = [
  '20살 미만',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
  '51',
  '52',
  '53',
  '54',
  '55',
  '56',
  '57',
  '58',
  '59',
  '60',
  '61',
  '62',
  '63',
  '64',
  '65',
  '66',
  '67',
  '68',
  '69',
  '70',
  '71',
  '72',
  '73',
  '74',
  '75',
  '76',
  '77',
  '78',
  '79',
  '80',
  '81',
  '82',
  '83',
  '84',
  '85',
  '86',
  '87',
  '88',
  '89',
  '90',
];

List kTennisAgeList = [
  "6개월 이하",
  "1년 이하",
  "1-2년",
  "2-3년",
  "3-4년",
  "4-5년",
  "5-6년",
  "6-7년",
  "7-8년",
  "8년 이상"
];

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;

class PostListView extends StatefulWidget {
  final String? postId;
  final String postType;
  const PostListView({Key? key, this.postId, required this.postType})
      : super(key: key);
  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  var post;
  late DateTime dt;
  late String d12;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPost().then((val) {
      setState(() {
        post = val;
        dt = (post["time"] as Timestamp).toDate();
        d12 = DateFormat('yyyy/MM/dd, hh:mm a').format(dt);
      });
    });
  }

  Future<Map<String, dynamic>?> getCurrentPost() async {
    final doc =
        await _firestore.collection(widget.postType).doc(widget.postId).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 24, right: 24),
      child: ListView(
        children: [
          Text(
            post["title"],
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 22,
          ),
          PostField(title: "시작시간", content: d12),
          PostField(title: "진행시간", content: post["match-time"]),
          PostField(title: "지역", content: post["place"]),
          PostField(title: "모집인원", content: post["member"]),
          PostField(title: "코트비", content: post["court-fee"]),
          PostField(title: "모집대상", content: post["member-requirement"]),
          PostField(
            title: "추가설명",
            content: post["additional-info"],
            bottomMargin: false,
          ),
        ],
      ),
    );
  }
}

class PostField extends StatelessWidget {
  const PostField({
    required this.title,
    this.content,
    this.bottomMargin = true,
  });

  final String title;
  final String? content;
  final bool bottomMargin;

  @override
  Widget build(BuildContext context) {
    if (content == null) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: kTextStyle),
        SizedBox(
          height: 6,
        ),
        Text(
          content!,
          style: TextStyle(fontSize: 17),
        ),
        SizedBox(
          height: bottomMargin ? 22 : 0,
        ),
      ],
    );
  }
}

const kTextStyle = TextStyle(
    color: Color(0x7f000000),
    fontSize: 14,
    decoration: TextDecoration.underline,
    decorationThickness: 3);

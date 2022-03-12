import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/components/profile_view.dart';
import 'package:tennis_friends_demo/components/rounded_button.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:tennis_friends_demo/components/post_list_view.dart';
import 'package:provider/provider.dart';
import 'post_modifying_screen.dart';
import 'package:tennis_friends_demo/screens/basic_screen.dart';
import 'court_modifying_screen.dart';
import '../basic_screen.dart';

class UserPostView extends StatelessWidget {
  static String id = "user_post_view";

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName(BasicScreen.id));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //ProfileLittleView(),
          Expanded(
              child: PostListView(
            postId: arguments["postId"],
            postType: arguments["postType"],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundedButton(
                    colour: Color(0xff27ac84),
                    title: "수정하기",
                    onPressed: () {
                      print(arguments["postId"]);
                      if (arguments["postType"] == "posts") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostModifyingScreen(
                                postId: arguments["postId"],
                              ),
                            ));
                      } else {
                        if (arguments["postType"] == "courts") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourtModifyingScreen(
                                      postId: arguments["postId"],
                                    )),
                          );
                        }
                      }
                    }),
                RoundedButton(
                    colour: Colors.black26,
                    title: "삭제하기",
                    onPressed: () async {
                      if (await Provider.of<UserData>(context, listen: false)
                          .deletePost(
                              arguments["postId"], arguments["postType"])) {
                        Navigator.popAndPushNamed(context, BasicScreen.id);
                      }
                      //TODO: 에러창
                    }),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

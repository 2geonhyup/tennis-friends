import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tennis_friends_demo/models/user_data.dart';
import 'package:provider/provider.dart';

class ProfileLittleView extends StatelessWidget {
  ProfileLittleView(
      {required this.nickName,
      required this.age,
      required this.gender,
      this.icon = true});
  bool icon;
  String nickName;
  String age;
  String gender;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 50, right: 18),
                  padding: EdgeInsets.all(0),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(100),
                  //     border: Border.all(width: 0.8, color: Colors.black26)),
                  child: Icon(
                    Icons.perm_identity,
                    size: 40,
                    //color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickName,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      age + gender.substring(0, 1),
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            icon
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Colors.black45,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
        SizedBox(
          height: 9,
        ),
        SizedBox(
          child: Divider(
            thickness: 0.8,
            color: Colors.black12,
          ),
        ),
      ],
    );
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(
                left: 25,
                right: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 0.8, color: Colors.black26)),
              child: Icon(
                Icons.person,
                size: 34,
                //color: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  Provider.of<UserData>(context).nickName!,
                  style: TextStyle(fontSize: 18.5),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  Provider.of<UserData>(context).age! +
                      Provider.of<UserData>(context).gender!.substring(0, 1) +
                      "  구력" +
                      Provider.of<UserData>(context).tennisAge!,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
        SizedBox(
          child: Divider(
            thickness: 0.8,
            color: Colors.black12,
          ),
        )
      ],
    );
  }
}

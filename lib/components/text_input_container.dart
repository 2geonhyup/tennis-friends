import 'package:flutter/material.dart';

class TextInputContainer extends StatefulWidget {
  TextInputContainer({
    required this.hint,
    required this.onChanged,
    this.maxLines = 2,
    this.value,
    this.bottomBorder = true,
    this.maxLength = 40,
    this.inputAction = TextInputAction.next,
  });

  final String hint;
  final int maxLines;
  final Function(String) onChanged;
  String? value;
  bool bottomBorder;
  int maxLength;
  TextInputAction inputAction;

  @override
  State<TextInputContainer> createState() => _TextInputContainerState();
}

class _TextInputContainerState extends State<TextInputContainer> {
  @override
  Widget build(BuildContext context) {
    //widget.value = "아웃";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: widget.bottomBorder == true
            ? Border(bottom: BorderSide(color: Colors.black12))
            : null,
      ),
      child: TextFormField(
        autofocus: true,
        initialValue: widget.value,
        onChanged: widget.onChanged,

        style: TextStyle(
          color: Colors.black,
        ),
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        textInputAction: widget.inputAction, // 다음 필드로 넘어가기
        decoration: InputDecoration(
            border: InputBorder.none, hintText: widget.hint, counterText: ""),
      ),
    );
  }
}

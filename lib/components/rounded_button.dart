import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    required this.colour,
    required this.title,
    required this.onPressed,
    this.height = 50,
    this.fontSize = 20,
  });

  final Color colour;
  final String title;
  final void Function() onPressed;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: height,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class RoundedWhiteButton extends StatelessWidget {
  RoundedWhiteButton({
    required this.title,
    required this.onPressed,
    this.height = 50,
    this.fontSize = 20,
    this.borderWidth = 1.6,
  });

  final String title;
  final void Function() onPressed;
  final double height;
  final double fontSize;
  final borderWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black45, width: borderWidth)),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 0.0,
          padding: EdgeInsets.all(0),
          height: height,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

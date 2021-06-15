import 'package:flutter/material.dart';
import 'package:spain_project/constants/constants.dart';

class MainButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;
  final bool isBlackText;
  MainButton(
      {this.onPressed,
      this.title,
      this.color = kButtonPrimaryColor,
      this.isBlackText = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
          width: double.infinity,
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                fontSize: 18, color: isBlackText ? Colors.black : Colors.white),
          ))),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }
}

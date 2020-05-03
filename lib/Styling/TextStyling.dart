import 'package:flutter/material.dart';

//DOnkt know if nice to capsule all in Class
class MyTextStyle {
  MyTextStyle();
  //Headlines
  static const TextStyle bigHeadline = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black); //Biggest Headline Text
  static const TextStyle mediumHeadline =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  //No SMall Headline Till now

  //Textstyle
  static const TextStyle normalText = TextStyle(fontSize: 14);
  static const TextStyle smallText = TextStyle(fontSize: 12);

  //Accent Sytle
  static const TextStyle iconStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
}

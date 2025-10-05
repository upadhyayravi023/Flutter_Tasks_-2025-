import 'package:flutter/material.dart';

class AppColors {
  static const Color redColor = Color(0xFFFAA6A6);
  static const Color greenColor = Color(0xFFA1FF9E);
  static const Color blueColor = Color(0xFF76D4FF);
  static const Color yellowColor = Color(0xFFF2FF7F);
  static const Color blackColor = Color(0xFFFFFFF);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const List<Color> reminderCardColors = [
    redColor,
    greenColor,
    yellowColor,
    blueColor,
  ];

  static Color getColorForIndex(int index) {
    return reminderCardColors[index % reminderCardColors.length];
  }
}
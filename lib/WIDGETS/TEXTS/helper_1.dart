
import 'package:flutter/material.dart';
import 'package:money_maker/CUSTOM/custom_font.dart';

class HelperText1 extends StatelessWidget {
  final String text;
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  const HelperText1(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.decoration = TextDecoration.none,
      this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: PerfectTypogaphy.bold.copyWith(
        fontSize: fontSize,
        // fontWeight: FontWeight.normal,
        color: color,
        decoration: decoration,
      ),
      textAlign: TextAlign.center,
    );
  }
}
import 'package:flutter/material.dart';

class BorderedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;

  const BorderedText({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.textColor,
    required this.strokeColor,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: textStyle.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}

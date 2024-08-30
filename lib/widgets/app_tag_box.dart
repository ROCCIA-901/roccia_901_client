import 'package:flutter/material.dart';

import '../constants/size_config.dart';

class AppTagBox extends StatelessWidget {
  final double height;
  final Color strokeColor;
  final Color backgroundColor;
  final Widget child;

  const AppTagBox({
    Key? key,
    required this.height,
    required this.strokeColor,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: strokeColor,
          width: AppSize.of(context).safeBlockHorizontal * 0.2,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/size_config.dart';

class ConfirmPopup extends StatelessWidget {
  final Text content;
  final List<Widget> actions;
  final double width;
  final double height;

  const ConfirmPopup({
    super.key,
    required this.content,
    required this.actions,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      title: Container(
        margin: EdgeInsets.only(top: height * 0.2),
        width: width,
        height: height * 0.8,
        alignment: Alignment.center,
        child: content,
      ),
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 3),
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      buttonPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
    );
  }
}

class ConfirmPopupButton extends StatelessWidget {
  final Text content;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const ConfirmPopupButton({
    super.key,
    required this.content,
    required this.backgroundColor,
    required this.onPressed,
    required this.width,
  }) : height = width * 3 / 7;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          backgroundColor: backgroundColor,
          textStyle: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}

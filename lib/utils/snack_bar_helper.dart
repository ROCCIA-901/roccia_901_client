import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showTextSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
  }

  static void showApiErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('에러 발생. 운영진에게 문의바랍니다.'),
        ),
      );
  }
}

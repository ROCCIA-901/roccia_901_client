import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/constants/size_config.dart';

class ToastHelper {
  static void show(
    BuildContext context,
    String message,
  ) {
    final ftoast = FToast().init(context);
    ftoast.removeCustomToast();
    ftoast.showToast(
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 90.0,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 4.0,
          vertical: SizeConfig.safeBlockHorizontal * 2.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.black.withOpacity(0.8),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          message,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4.0,
            color: Colors.white,
          ),
        ),
      ),
      toastDuration: Duration(seconds: 2),
    );
  }

  static void showUnimplemented(BuildContext context) {
    show(context, '아직 완성하지 못한 기능이에요. 😢\n곧 업데이트할게요!');
  }

  static void showErrorOccurred(BuildContext context) {
    show(context, '알 수 없는 에러가 발생하였습니다. 운영진에게 알려주세요!');
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/constants/size_config.dart';

class ToastHelper {
  static void show(BuildContext context, String message) {
    FToast().init(context).showToast(
          child: Container(
            width: SizeConfig.safeBlockHorizontal * 90,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 4.0,
              vertical: SizeConfig.safeBlockVertical * 1.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              message,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                color: Colors.white,
              ),
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
  }
}

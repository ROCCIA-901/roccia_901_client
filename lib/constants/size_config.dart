import 'dart:math';

import 'package:flutter/material.dart';

class SizeConfig {
  static const double _maxMobileWidth = 768;

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static late AppFontSize font;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    // Limit the safe width to a maximum of mobile width
    final double safeHeight = screenHeight - _safeAreaVertical;
    double safeWidth =
        min((screenWidth - _safeAreaHorizontal), _maxMobileWidth);
    safeWidth = min(safeWidth, safeHeight * 0.7);

    safeBlockHorizontal = safeWidth / 100;
    safeBlockVertical = safeHeight / 100;

    font = AppFontSize(safeBlockHorizontal);
  }
}

class AppFontSize {
  final double _safeBlockHorizontal;

  AppFontSize(this._safeBlockHorizontal) {
    setFontSizes();
  }

  late double headline1;
  late double headline2;
  late double headline3;

  void setFontSizes() {
    headline1 = _safeBlockHorizontal * 5.5;
    headline2 = _safeBlockHorizontal * 4;
    headline3 = _safeBlockHorizontal * 3.5;
  }
}

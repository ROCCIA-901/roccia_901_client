import 'dart:math';

import 'package:flutter/material.dart';

/// Todo: 지우기
class SizeConfig {
  static const double _maxMobileWidth = 768;

  late final MediaQueryData _mediaQueryData;
  late final double screenWidth;
  late final double screenHeight;
  late final double blockSizeHorizontal;
  late final double blockSizeVertical;

  late final double _safeAreaHorizontal;
  late final double _safeAreaVertical;
  late final double safeBlockHorizontal;
  late final double safeBlockVertical;

  late final AppFontSize font;

  SizeConfig({
    BuildContext? context,
  }) {
    init(context: context);
  }

  void init({BuildContext? context}) {
    _mediaQueryData = context != null
        ? MediaQuery.of(context)
        : MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single);
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

class AppSize extends InheritedWidget {
  static const double _maxMobileWidth = 768;

  late final MediaQueryData _mediaQueryData;
  late final double screenWidth;
  late final double screenHeight;
  late final double blockSizeHorizontal;
  late final double blockSizeVertical;

  late final double _safeAreaHorizontal;
  late final double _safeAreaVertical;
  late final double safeBlockHorizontal;
  late final double safeBlockVertical;

  late final AppFontSize font;

  AppSize({
    Key? key,
    BuildContext? context,
    required Widget child,
  }) : super(key: key, child: child) {
    init(context: context);
  }

  void init({BuildContext? context}) {
    _mediaQueryData = context != null
        ? MediaQuery.of(context)
        : MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single);
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

  static AppSize of(BuildContext context) {
    final AppSize? result =
        context.dependOnInheritedWidgetOfExactType<AppSize>();
    assert(result != null, 'No StaSizeConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppSize oldWidget) {
    if (oldWidget.screenWidth != screenWidth ||
        oldWidget.screenHeight != screenHeight) {
      return true;
    }
    return false;
  }
}

class AppFontSize {
  final double _safeBlockHorizontal;

  AppFontSize(this._safeBlockHorizontal) {
    setFontSizes();
  }

  late double title;
  late double headline1;
  late double headline2;
  late double headline3;
  late double content;

  void setFontSizes() {
    title = _safeBlockHorizontal * 5.5;
    headline1 = _safeBlockHorizontal * 5.0;
    headline2 = _safeBlockHorizontal * 4.5;
    headline3 = _safeBlockHorizontal * 4;
    content = _safeBlockHorizontal * 3.5;
  }
}

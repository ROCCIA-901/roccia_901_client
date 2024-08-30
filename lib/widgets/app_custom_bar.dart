import 'package:flutter/material.dart';

import '../constants/size_config.dart';

PreferredSize buildAppCommonBar(BuildContext context, {String? title, Widget? leading}) {
  final double appBarHeight = AppSize.of(context).safeBlockHorizontal * 12;
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: AppBar(
      toolbarHeight: appBarHeight,
      automaticallyImplyLeading: false,
      leading: leading,
      leadingWidth: AppSize.of(context).safeBlockHorizontal * 10,
      title: title != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: AppSize.of(context).font.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : null,
      titleSpacing: leading != null
          ? -(AppSize.of(context).safeBlockHorizontal * 1)
          : (AppSize.of(context).safeBlockHorizontal * 5),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
  );
}

class AppSliverBar extends StatelessWidget {
  final String? title;

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late final double _appBarHeight;

  AppSliverBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title ?? '',
        style: TextStyle(
          fontSize: AppSize.of(context).font.title,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleSpacing: AppSize.of(context).safeBlockHorizontal * 5,
      backgroundColor: Colors.white,
      toolbarHeight: _appBarHeight,
      floating: false,
    );
  }

  void _updateSize(BuildContext context) {
    _appBarHeight = AppSize.of(context).safeBlockHorizontal * 12;
  }
}

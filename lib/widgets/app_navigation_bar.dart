import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/size_config.dart';

import '../constants/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _height;

  static const List<String> _icons = [
    "assets/icons/navi_home.svg",
    "assets/icons/navi_calendar.svg",
    "assets/icons/navi_crown.svg",
    "assets/icons/navi_person.svg",
  ];
  static const List<String> _selectedIcons = [
    "assets/icons/navi_home_selected.svg",
    "assets/icons/navi_calendar_selected.svg",
    "assets/icons/navi_crown_selected.svg",
    "assets/icons/navi_person_selected.svg",
  ];
  static const List<String> _labels = ['홈', '기록', '랭킹', '마이페이지'];

  @override
  Widget build(BuildContext context) {
    _height = AppSize.of(context).safeBlockVertical * 8.5;
    return SizedBox(
      height: _height,
      child: BottomNavigationBar(
        backgroundColor: Color(0xfffbfbfb),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: AppColors.primary,
        selectedFontSize: AppSize.of(context).safeBlockVertical * 1.5,
        unselectedFontSize: AppSize.of(context).safeBlockVertical * 1.5,
        unselectedItemColor: Colors.grey,
        items: _buildItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildItems() {
    return List.generate(
      _icons.length,
      (index) => BottomNavigationBarItem(
        icon: SvgPicture.asset(
          currentIndex == index ? _selectedIcons[index] : _icons[index],
          height: _height * 0.45,
        ),
        label: _labels[index],
      ),
    );
  }
}

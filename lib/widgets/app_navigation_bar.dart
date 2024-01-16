import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: BottomNavigationBar(
        backgroundColor: Color(0xfffbfbfb),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onItemSelected,
        selectedItemColor: const Color(0xffcae4c1),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 40,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diversity_1),
            label: '대회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}

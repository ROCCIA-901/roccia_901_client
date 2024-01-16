import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/home/home_screen.dart';
import 'screens/history/my_record_screen.dart';
import 'screens/competition/competition_screen.dart';
import 'screens/mypage/my_page_screen.dart';

void main() {
  initializeDateFormatting().then((_)=>
      runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bottomNavigationBar',
      home: Roccia(),
    );
  }
}

class Roccia extends StatefulWidget {
  @override
  _RocciaState createState() => _RocciaState();
}

class _RocciaState extends State<Roccia> {
  int currentIndex =0;
  final screens = [
    HomeScreen(),
    MyRecordScreen(),
    CompetitionScreen(),
    MyPageScreen(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomNavigationBar(
          backgroundColor: Color(0xfffbfbfb),
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setState(() =>currentIndex = index),
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
      ),
    );
  }
}
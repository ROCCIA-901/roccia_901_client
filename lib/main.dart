import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home.dart';
import 'pages/history/record.dart';
import 'pages/competition.dart';
import 'pages/mypage.dart';

void main() {
  initializeDateFormatting().then((_)=>
      runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bottomNavigationBar',
      home: roccia(),
    );
  }
}

class roccia extends StatefulWidget {
  @override
  _rocciaState createState() => _rocciaState();
}

class _rocciaState extends State<roccia> {
  int currentIndex =0;
  final screens = [
    home(),
    record(),
    competition(),
    mypage(),
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
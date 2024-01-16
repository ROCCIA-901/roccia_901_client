import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:untitled/widgets/app_navigation_bar.dart';

import 'pages/home.dart';
import 'pages/history/record.dart';
import 'pages/competition.dart';
import 'pages/mypage.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
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
  int currentIndex = 0;
  final screens = [
    home(),
    record(),
    competition(),
    mypage(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: AppNavigationBar(
        currentIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

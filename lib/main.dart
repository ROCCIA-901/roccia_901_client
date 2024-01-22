import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:untitled/widgets/app_navigation_bar.dart';

import 'screens/home_screen.dart';
import 'screens/my_record_screen.dart';
import 'screens/competition_screen.dart';
import 'screens/my_page_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
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
  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    MyRecordScreen(),
    CompetitionScreen(),
    MyPageScreen(),
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

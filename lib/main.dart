import 'package:flutter/material.dart';
import 'package:untitled/screens/tmp_all_screen_list_screen.dart';
import 'package:untitled/utils/app_routes.dart';
import 'package:untitled/utils/app_theme.dart';
import 'package:untitled/widgets/app_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/member_home_screen.dart';
import 'screens/record_screen/my_record_tab.dart';
import 'screens/competition_screen.dart';
import 'screens/my_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); // Initialize for default locale
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bottomNavigationBar',
      theme: AppTheme.lightTheme,
      home: TmpAllScreenListScreen(),
      routes: AppRoutes.routes,
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
    MemberHomeScreen(),
    MyRecordTab(),
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

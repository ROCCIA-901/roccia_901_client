import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/size_config.dart';
import 'presentation/screens/tmp_all_screen_list_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); // Initialize for default locale
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'bottomNavigationBar',
      theme: AppTheme.lightTheme,
      home: TmpAllScreenListScreen(),
      routes: AppRoutes.routes,
    );
  }
}

// class Roccia extends StatefulWidget {
//   @override
//   _RocciaState createState() => _RocciaState();
// }
//
// class _RocciaState extends State<Roccia> {
//   int currentIndex = 0;
//
//   final screens = [
//     MemberHomeScreen(),
//     MyRecordTab(),
//     CompetitionScreen(),
//     MyPageScreen(),
//   ];
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[currentIndex],
//       bottomNavigationBar: AppNavigationBar(
//         currentIndex: currentIndex,
//         onItemSelected: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

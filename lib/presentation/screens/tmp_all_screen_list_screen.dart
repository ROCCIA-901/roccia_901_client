import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/data/shared/app_storage.dart';
import 'package:untitled/utils/app_logger.dart';

import 'attendance_request_screen.dart';
import 'attendance_history_screen.dart';
import 'attendance_approval_screen.dart';

class _DevAppRoutes {
  static Map<String, Widget> routes = {
    "/attendanceApprovalScreen": AttendanceApprovalScreen(),
    "/attendance-history-screen": AttendanceHistoryScreen(),
    // "attendanceManagementScreen": AttendanceManagementScreen(),
    "/attendance-request": AttendanceRequestScreen(),
    // competitionScreen: CompetitionScreen(),
    // emailVerificationScreen: EmailVerificationScreen(),
    // loginScreen: LoginScreen(),
    // memberHomeScreen: MemberHomeScreen(),
    // myPageScreen: MyPageScreen(),
    // recordScreen: RecordScreen(),
    // passwordResetScreen: PasswordResetScreen(email: "aaa@aaa.aaa"),
    // signUpScreen: SignUpScreen(),
    // splashScreen: SplashScreen(),
  };
}

class TmpAllScreenListScreen extends ConsumerWidget {
  TmpAllScreenListScreen({super.key});

  final List routeNames = _DevAppRoutes.routes.keys.toList();

  Future<void> tmpLog(ref) async {
    final appStorage = ref.watch(appStorageProvider);
    logger.d(
        "App Storage: ${await appStorage.read(key: 'access_token')}, ${await appStorage.read(key: 'refresh_token')}");
  }

  Widget listItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => _DevAppRoutes.routes[routeNames[index]]!));
      },
      child: Container(
        height: 45,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.only(left: 12),
        alignment: Alignment.centerLeft,
        decoration: ShapeDecoration(
          color: Color(0xFFCAE4C1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          routeNames[index].substring(1),
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    tmpLog(ref);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Scrollbar(
          interactive: true,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 8,
          radius: Radius.circular(10),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _DevAppRoutes.routes.length,
            itemBuilder: (BuildContext context, int index) => listItem(context, index),
          ),
        ),
      ),
    );
  }
}

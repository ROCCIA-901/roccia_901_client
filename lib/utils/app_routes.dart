import 'package:flutter/material.dart';

import '../presentation/screens/attendance_history_screen.dart';
import '../presentation/screens/attendance_request_screen.dart';
import '../presentation/screens/competition_screen.dart';
import '../presentation/screens/email_verification_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/member_home_screen.dart';
import '../presentation/screens/my_page/my_page_screen.dart';
import '../presentation/screens/password_reset_screen.dart';
import '../presentation/screens/record/record_screen.dart';
import '../presentation/screens/sign_up_screen.dart';

class AppRoutes {
  static const String attendanceApprovalScreen = '/attendance_approval_screen';
  static const String attendanceHistoryScreen = '/attendance_history_screen';
  static const String attendanceManagementScreen =
      '/attendance_management_screen';
  static const String attendanceRequestScreen = '/attendance_request_screen';
  static const String competitionScreen = '/competition_screen';
  static const String emailVerificationScreen = '/email_verification_screen';
  static const String loginScreen = '/login_screen';
  static const String memberHomeScreen = '/member_home_screen';
  static const String myPageScreen = '/my_page_screen';
  static const String recordScreen = '/record_screen';
  static const String passwordResetScreen = '/password_reset_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String splashScreen = '/splash_screen';

  static Map<String, WidgetBuilder> routes = {
    // attendanceApprovalScreen: (context) => AttendanceApprovalScreen(),
    attendanceHistoryScreen: (context) => AttendanceHistoryScreen(),
    // attendanceManagementScreen: (context) => AttendanceManagementScreen(),
    attendanceRequestScreen: (context) => AttendanceRequestScreen(),
    competitionScreen: (context) => CompetitionScreen(),
    emailVerificationScreen: (context) => EmailVerificationScreen(),
    loginScreen: (context) => LoginScreen(),
    memberHomeScreen: (context) => MemberHomeScreen(),
    myPageScreen: (context) => MyPageScreen(),
    recordScreen: (context) => RecordScreen(),
    // ToDo: Remove this line after implementing the password reset screen
    passwordResetScreen: (context) => PasswordResetScreen(email: "aaa@aaa.aaa"),
    signUpScreen: (context) => SignUpScreen(),
    // splashScreen: (context) => SplashScreen(),
  };
}

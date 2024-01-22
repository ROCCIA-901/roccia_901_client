import 'package:flutter/material.dart';
import 'package:untitled/screens/attendance_approval_screen.dart';
import 'package:untitled/screens/attendance_history_screen.dart';
import 'package:untitled/screens/attendance_management_screen.dart';
import 'package:untitled/screens/attendance_request_screen.dart';
import 'package:untitled/screens/competition_screen.dart';
import 'package:untitled/screens/email_verification_screen.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/member_home_screen.dart';
import 'package:untitled/screens/my_page_screen.dart';
import 'package:untitled/screens/password_reset_screen.dart';
import 'package:untitled/screens/sign_up_screen.dart';
import 'package:untitled/screens/splash_screen.dart';
import 'package:untitled/screens/staff_home_screen.dart';

import '../screens/record_screen/record_screen.dart';

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
  static const String staffHomeScreen = '/staff_home_screen';

  static Map<String, WidgetBuilder> routes = {
    attendanceApprovalScreen: (context) => AttendanceApprovalScreen(),
    attendanceHistoryScreen: (context) => AttendanceHistoryScreen(),
    attendanceManagementScreen: (context) => AttendanceManagementScreen(),
    attendanceRequestScreen: (context) => AttendanceRequestScreen(),
    competitionScreen: (context) => CompetitionScreen(),
    emailVerificationScreen: (context) => EmailVerificationScreen(),
    loginScreen: (context) => LoginScreen(),
    memberHomeScreen: (context) => MemberHomeScreen(),
    myPageScreen: (context) => MyPageScreen(),
    recordScreen: (context) => RecordScreen(),
    passwordResetScreen: (context) => PasswordResetScreen(),
    signUpScreen: (context) => SignUpScreen(),
    splashScreen: (context) => SplashScreen(),
    staffHomeScreen: (context) => StaffHomeScreen(),
  };
}

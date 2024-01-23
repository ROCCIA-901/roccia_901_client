import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFCAE4C1),
          primary: Color(0xFFCAE4C1),
          onPrimary: Colors.white,
          background: Colors.white,
          brightness: Brightness.light,
        ),
      );
}

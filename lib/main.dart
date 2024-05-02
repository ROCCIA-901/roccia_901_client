import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/size_config.dart';
import 'utils/app_router.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko'); // Initialize for default locale
  runApp(
    ProviderScope(child: Builder(
      builder: (context) {
        return MyWebApp();
      },
    )),
  );
}

class MyWebApp extends ConsumerWidget {
  MyWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: AppRouter(ref).config(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: AppSize(
            context: context,
            child: MyAppBox(child: child!),
          ),
        );
      },
    );
  }
}

class MyAppBox extends StatelessWidget {
  final Widget? child;

  const MyAppBox({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        child: SizedBox(
          width: AppSize.of(context).safeBlockHorizontal * 100,
          // width: SizeConfig(context: context).safeBlockHorizontal * 100,
          child: child!,
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: AppRouter(ref).config(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}

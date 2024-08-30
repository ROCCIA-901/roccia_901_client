import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:untitled/presentation/screens/tmp_all_screen_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/size_config.dart';
import 'utils/app_router.dart';
import 'utils/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko'); // Initialize for default locale
  runApp(
    ProviderScope(child: Builder(
      builder: (context) {
        // return MyDevWebApp();
        return MyWebApp();
      },
    )),
  );
}

class MyWebApp extends ConsumerWidget {
  MyWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: "ROCCIA 901",
      routerConfig: appRouter!.config(),
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
    final AppRouter appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: appRouter!.config(),
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

class MyDevWebApp extends ConsumerWidget {
  MyDevWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "ROCCIA 901",
      debugShowCheckedModeBanner: true,
      theme: AppTheme.lightTheme,
      home: TmpAllScreenListScreen(),
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

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_guide/providers/task_provider.dart';
import 'package:ramadan_guide/providers/theme_provider.dart';
import 'package:ramadan_guide/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ramadan_guide/providers/dua_provider.dart';
import 'package:ramadan_guide/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await Future.delayed(Duration.zero); // للتأكد من تحميل الثيم
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: themeProvider),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(create: (_) => DuaProvider()),
    ],
    child: const MyApp(),
  ));
}

class RamadanGuideApp extends StatelessWidget {
  const RamadanGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DuaProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          locale: const Locale('ar'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
        Locale('ar', 'AE'),
          ],
          title: 'تنظيم عبادات رمضان',
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}

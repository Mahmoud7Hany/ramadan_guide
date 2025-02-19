// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ramadan_guide/providers/task_provider.dart';
import 'package:ramadan_guide/providers/theme_provider.dart';
import 'package:ramadan_guide/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ramadan_guide/providers/dua_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 100)); // تأخير بسيط لضمان تحميل الثيم
  runApp(const RamadanGuideApp());
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
        if (!themeProvider.isInitialized) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                color: const Color(0xFF121212),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF81C784),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'جاري تحميل التطبيق...',
                        style: GoogleFonts.cairo(
                          color: const Color(0xFF81C784),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'AE'),
          ],
          title: 'تنظيم عبادات - رمضان',
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.cairo().fontFamily,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              secondary: Color(0xFF66BB6A),
              tertiary: Color(0xFF43A047),
              surface: Colors.white,
              background: Color(0xFFF8F9FA),
              error: Color(0xFFD32F2F),
              onPrimary: Colors.white,
              onSecondary: Colors.black87,
              onSurface: Color(0xFF1C1B1F),
              onBackground: Color(0xFF1C1B1F),
              primaryContainer: Color(0xFFB9F6CA),
              onPrimaryContainer: Color(0xFF002107),
              secondaryContainer: Color(0xFFDCEDC8),
              onSecondaryContainer: Color(0xFF1B1B1B),
              errorContainer: Color(0xFFFFDAD6),
              onErrorContainer: Color(0xFF410002),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.green,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.cairo().fontFamily,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF81C784),
              secondary: const Color(0xFF66BB6A),
              tertiary: const Color(0xFF4CAF50),
              surface: const Color(0xFF1E1E1E),
              background: const Color(0xFF121212),
              error: const Color(0xFFCF6679),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.white,
              onBackground: Colors.white,
              primaryContainer: const Color(0xFF1E4620),
              onPrimaryContainer: const Color(0xFFB9F6CA),
              secondaryContainer: Colors.grey[800]!,
              onSecondaryContainer: Colors.white,
              errorContainer: const Color(0xFF590007),
              onErrorContainer: const Color(0xFFFFB4AB),
            ),
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1E1E1E),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.5),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

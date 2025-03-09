import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fridge_finds/home_page.dart';
import 'package:fridge_finds/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importing the screens
import 'settings/language_screen.dart';
import 'settings/account_screen.dart';
import 'settings/notification_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/storage_screen.dart';
import 'settings/help_screen.dart';
import 'settings/update_screen.dart';

import 'grocery_list.dart';
import 'inventory_tracking.dart';
import 'expiry_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// ✅ Added the missing MyApp class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: (themeProvider.isDarkMode) ? ThemeData.dark() : ThemeData.light(),
          home: const HomeScreen(userName: 'User'), // Ensure HomeScreen is correctly imported
        );
      },
    );
  }
}

// Theme Provider to manage dark mode
class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  bool get getDarkMode => isDarkMode;

  Future<void> toggleTheme(bool value) async {
    isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}

// Language Provider to switch language
class LanguageProvider with ChangeNotifier {
  String language = 'English';

  void changeLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
  }
}
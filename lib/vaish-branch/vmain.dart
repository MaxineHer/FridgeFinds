import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importing the screens
import 'settings/language_screen.dart';
import 'settings/account_screen.dart';
import 'settings/notification_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/storage_screen.dart';
import 'settings/help_screen.dart';
import 'settings/update_screen.dart';
import 'package:fridge_finds/manasvi-branch/userprofile_page.dart';
import 'grocery_list.dart';
import 'package:fridge_finds/manasvi-branch/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:fridge_finds/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default theme
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // Boolean to track dark mode
  TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30), // Increased icon size
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 30), // Increased icon size
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            leading: Icon(Icons.language, color: Color(0xFF6E86D0), size: 30), // Increased icon size
            title: Text(
              "App Language",
              style: TextStyle(fontFamily: 'Sen', fontSize: 22), // Increased font size
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
          _buildSettingItem(context, "Account", Icons.person, AccountScreen()),
         // _buildSettingItem(context, "Notifications", Icons.notifications, NotificationSettingsPage()),
          _buildSettingItem(context, "Notifications", Icons.notifications, PrivacyScreen()),
          _buildSettingItem(context, "Privacy", Icons.lock, PrivacyScreen()),
          _buildSettingItem(context, "Storage and Data", Icons.storage, StorageScreen()),
          _buildSettingItem(context, "Help", Icons.help, HelpScreen()),
          _buildSettingItem(context, "App Update", Icons.update, UpdateScreen()),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF6E86D0), size: 30), // Increased icon size
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Sen', fontSize: 22), // Increased font size
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // List of settings titles to search through
  final List<String> settingsList = [
    'App Language',
    'Account',
    'Notifications',
    'Privacy',
    'Storage and Data',
    'Help',
    'App Update',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, size: 30),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, size: 30),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = settingsList
        .where((setting) => setting.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(fontFamily:'PlayfairDisplay' ,fontSize: 20),
        ),
      );
    }

    return ListView(
      children: results.map((result) {
        return ListTile(
          title: Text(result, style: TextStyle(fontFamily:'PlayfairDisplay', fontSize: 20)),
          onTap: () {
            Navigator.pop(context); // Close the search delegate
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = settingsList
        .where((setting) => setting.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: suggestions.map((suggestion) {
        return ListTile(
          title: Text(suggestion, style: TextStyle(fontSize: 20)),
          onTap: () {
            query = suggestion;
            showResults(context); // Show results immediately after selecting a suggestion
          },
        );
      }).toList(),
    );
  }
}
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF6E86D0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const HomeScreen(userName: 'User' ), // Home screen page
                ),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroceryListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.list, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPage(),
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
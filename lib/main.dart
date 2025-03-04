import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//language import
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

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

void main() {
  runApp(MyApp());
}

// Theme Provider to manage dark mode
class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  Future<void> toggleTheme(bool value) async {
    isDarkMode = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: SettingsScreen(),
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 36, // Increased font size
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
            leading: Icon(Icons.dark_mode, color: Color(0xFF642ef3), size: 30), // Increased icon size
            title: Text(
              "Dark Mode",
              style: TextStyle(fontFamily: 'Sen', fontSize: 22), // Increased font size
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: Color(0xFF642ef3), size: 30), // Increased icon size
            title: Text(
              "App Language",
              style: TextStyle(fontFamily: 'Sen', fontSize: 22), // Increased font size
            ),
            subtitle: Text(
              languageProvider.language,
              style: TextStyle(fontFamily: 'Sen', fontSize: 20), // Increased font size
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
          _buildSettingItem(context, "Account", Icons.person, AccountScreen()),
          _buildSettingItem(context, "Notifications", Icons.notifications, NotificationScreen()),
          _buildSettingItem(context, "Privacy", Icons.lock, PrivacyScreen()),
          _buildSettingItem(context, "Storage and Data", Icons.storage, StorageScreen()),
          _buildSettingItem(context, "Help", Icons.help, HelpScreen()),
          _buildSettingItem(context, "App Update", Icons.update, UpdateScreen()),
          _buildSettingItem(context, "Grocery List", Icons.list, GroceryListScreen()),
          _buildSettingItem(context, "Inventory Tracker", Icons.track_changes, InventoryTrackingScreen()),
          _buildSettingItem(context, "Expiry Details", Icons.date_range, ExpiryDetailsScreen()),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 40, color: Colors.white), // Increased icon size
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 40, color: Colors.white), // Increased icon size
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40, color: Colors.white), // Increased icon size
              label: "",
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Color(0xFF6E86D0),
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF642ef3), size: 30), // Increased icon size
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
    'Dark Mode',
    'App Language',
    'Account',
    'Notifications',
    'Privacy',
    'Storage and Data',
    'Help',
    'App Update',
    'Grocery List',
    'Inventory Tracker',
    'Expiry Details',
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
    // Filter the settings list based on the search query
    final results = settingsList
        .where((setting) => setting.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // If there are no results, show a message indicating that
    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView(
      children: results.map((result) {
        return ListTile(
          title: Text(result, style: TextStyle(fontSize: 20)),
          onTap: () {
            // Navigate to the corresponding page based on the search result
            Navigator.pop(context); // Close the search delegate first

            // Using Navigator.push to navigate to the corresponding screen
            switch (result) {
              case 'App Language':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()),
                );
                break;
              case 'Account':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
                break;
              case 'Notifications':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
                break;
              case 'Privacy':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyScreen()),
                );
                break;
              case 'Storage and Data':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorageScreen()),
                );
                break;
              case 'Help':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
                break;
              case 'App Update':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateScreen()),
                );
                break;
              case 'Grocery List':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryListScreen()),
                );
                break;
              case 'Inventory Tracker':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryTrackingScreen()),
                );
                break;
              case 'Expiry Details':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpiryDetailsScreen()),
                );
                break;
              default:
                break;
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter suggestions while typing
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
} //test

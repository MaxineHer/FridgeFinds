import 'package:flutter/material.dart';
import 'package:fridge_finds/login.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'personal_info_page.dart';
import 'package:fridge_finds/tahera-branch/tmain.dart';
import 'package:fridge_finds/tahera-branch/adduser.dart';
import 'package:fridge_finds/vaish-branch/vmain.dart';
import 'package:fridge_finds/vaish-branch/grocery_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserPage(key: Key('userPage')),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners for dialog
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to Log Out?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Sen'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.blue, fontSize: 18, fontFamily: 'Sen'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle logout logic here (e.g., clear data, etc.)
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );// Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User logged out')),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.red, fontSize: 18, fontFamily: 'Sen'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: null,
        automaticallyImplyLeading: false, // Disable back arrow automatically
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Move the "User Profile" heading and other widgets up
            SizedBox(height: 0), // Reduced space between heading and profile picture
            // Profile Picture and Name
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFCDE1F5),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 10), // Reduced space between picture and name
            Text(
              'Jane Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'PlayfairDisplay', // Set the name font to Playfair Display
              ),
            ),
            SizedBox(height: 16), // Reduced space between name and buttons
            // Move buttons up
            _buildCustomButton(context, Icons.account_circle, 'Personal Info', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
              );
            }),/*
            SizedBox(height: 20),
            _buildCustomButton(context, Icons.person_add, 'Add New User', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserScreen()),
              );
            }),*/
            SizedBox(height: 15),
            _buildCustomButton(context, Icons.notifications, 'Notifications', onPressed: () {
              // Navigate to Notifications Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            }),
            SizedBox(height: 15),
            _buildCustomButton(context, Icons.help_outline, 'FAQs', onPressed: () {
              // Navigate to Notifications Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            }),
            SizedBox(height: 15),
            _buildCustomButton(context, Icons.settings, 'Settings', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SettingsScreen()),
              );
            }),
            Spacer(),
            SizedBox(height: 20),
            // Logout Button
            _buildCustomButton(context, Icons.logout, 'Log Out', backgroundColor: Colors.red.shade300, onPressed: () {
              _showLogoutDialog(context); // Show logout dialog when pressed
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  // Custom button widget to improve aesthetics
  Widget _buildCustomButton(BuildContext context, IconData icon, String text, {Color? backgroundColor, void Function()? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? () {}, // Handle the navigation if provided
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFFCDE1F5), // Background color
        foregroundColor: Colors.black, // Text color
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Smooth rounded corners
        ),
        elevation: 10, // Adding more shadow for a floating effect
        shadowColor: Colors.grey.withOpacity(0.5), // Lighter shadow
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sen', // Set button font to Sen
            ),
          ),
        ],
      ),
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
                  const HomeScreen(userName: 'User'), // Home screen page
                ),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
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
              // Navigate to Profile Page
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogOutPage(), // Home screen now leads to LogOutPage
    );
  }
}

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  // Function to show logout dialog
  void showLogoutDialog(BuildContext context) {
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.blue, fontSize: 18 , fontFamily: 'Sen'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle logout logic here (e.g., clear data, etc.)
                        Navigator.of(context).pop(); // Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User logged out')),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.red, fontSize: 18 , fontFamily: 'Sen'),
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
      appBar: AppBar(
        title: Text('Log Out Screen', style: TextStyle(fontFamily: 'Sen')),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showLogoutDialog(context), // Show the dialog when pressed
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            textStyle: TextStyle(fontSize: 18, fontFamily: 'Sen'),
          ),
          child: Text('Logout', style: TextStyle(fontSize: 18, fontFamily: 'Sen')),
        ),
      ),
    );
  }
}

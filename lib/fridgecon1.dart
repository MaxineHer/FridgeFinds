import 'package:flutter/material.dart';
import 'addfridge.dart';
import 'real_time_view_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF6E86D0),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      selectedFontSize: 0,
      unselectedFontSize: 0,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: ""),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figma Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FridgeConnectivityScreen(),
    );
  }
}

class FridgeConnectivityScreen extends StatelessWidget {
  const FridgeConnectivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Connections',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddFridgeQRScreen()),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.kitchen,
                          size: 40,
                          color: Colors.blue,
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          'Add Fridge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // "Add User" (SECOND BUTTON)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RealTimeViewScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Real Time View',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 40),

              const Text(
                'Connected Fridge',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

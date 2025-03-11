import 'package:flutter/material.dart';
import 'onboarding.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7), // Light Blue Background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // **FridgeFinds Logo**
              Image.asset(
                'assets/ff_logo.png',
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Logo not found", style: TextStyle(color: Colors.red));
                },
              ),

              const SizedBox(height: 10),

              // **Title**
              const Text(
                'FridgeFinds',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Playfair_Display', // Custom Font
                ),
              ),

              // **Subtitle**
              const Text(
                'Smart Choices, Fresh Living!',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              // **Next Button**
              SizedBox(
                width: 175,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Onboarding()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Color(0xFF5A7EB1), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

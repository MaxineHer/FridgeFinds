import 'package:flutter/material.dart';
import 'login.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Illustration/Image
              SizedBox(
                height: 300,
                child: Center(
                  child: Image.asset(
                    'assets/ob2.png',
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Title & Subtitle
              Column(
                children: const [
                  SizedBox(height: 30), // Match spacing with Onboarding1
                  SizedBox(
                    width: 252,
                    child: Text(
                      'Smart Inventory, Easy Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.w700,
                        height: 1.31,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 280,
                    child: Text(
                      'Enjoy your fridge, organized and always ready',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Sen',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 0),

              // Next & Skip Buttons
              Column(
                children: [
                  SizedBox(
                    width: 165,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA7C7E7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

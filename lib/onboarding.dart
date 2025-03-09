
import 'package:flutter/material.dart';
import 'onboarding2.dart';
import 'login.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensures full white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // Adjust side padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements properly
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Small spacing at the top

              // Illustration/Image
              SizedBox(
                height: 300, // Adjust height to fit nicely
                child: Center(
                  child: Image.asset(
                    'assets/ob1.png',
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Title and Subtitle
              Column(
                children: const [
                  SizedBox(height: 30),
                  SizedBox(
                    width: 252,
                    child: Text(
                      'Freshness at your Fingertips',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25, // Increased size for better visibility
                        fontFamily: 'fonts/PlayfairDisplay-Bold.ttf',
                        fontWeight: FontWeight.w700,
                        height: 1.31, // Adjusted line height
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 280,
                    child: Text(
                      'Effortlessly manage your fridge\nfrom the comfort of your phone',
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

              const SizedBox(height: 0), // Adjust spacing

              // Next and Skip Buttons
              Column(
                children: [
                  SizedBox(
                    width: 165,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Onboarding2()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA7C7E7),
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
                    onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );},
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}




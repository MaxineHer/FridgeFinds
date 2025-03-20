import 'package:flutter/material.dart';
import 'login.dart';
import 'signupsuccess.dart';

class Verification extends StatefulWidget {
  final String email; // Receive email from Registration Page
  final String name;  // Receive name from Registration Page

  const Verification({super.key, required this.email, required this.name});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<Verification> {
  final TextEditingController _otpController = TextEditingController();
  bool isButtonEnabled = false;

  void _checkOTP() {
    setState(() {
      isButtonEnabled = _otpController.text.length == 6; // Enable button if 6 digits are entered
    });
  }

  void _verifyCode() {
    if (_otpController.text.length == 6) {
      _showSuccessDialog("Verification Successful", "Your account has been verified!");
    } else {
      _showErrorDialog("Invalid Code", "Please enter a 6-digit verification code.");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.green)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupSuccess(name: widget.name), 
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );//
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            // **Curved Blue Background**
            Stack(
              children: [
                Container(
                  height: 280,
                  color: const Color(0xFFA7C7E7), // Light Blue Background
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/ff_logo.png',
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text("Logo not found", style: TextStyle(color: Colors.red));
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'FridgeFinds',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // **Verification Form Container**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // **Instruction Text with Dynamic Email**
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "A 6-digit verification code has been sent to **${widget.email}**.\nPlease enter it below!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // **OTP Input Field**
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      obscureText: true, // Masking the input
                      onChanged: (value) => _checkOTP(),
                      decoration: InputDecoration(
                        hintText: "● ● ● ● ● ●",
                        hintStyle: const TextStyle(
                          fontSize: 24,
                          letterSpacing: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // **Continue Button**
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled ? _verifyCode : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonEnabled
                              ? const Color(0xFFA7C7E7)
                              : Colors.blueGrey[200], // Disabled button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


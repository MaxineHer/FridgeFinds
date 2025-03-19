import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'signupsuccess.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _validateLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorDialog("Invalid Email Format", "Please enter a valid email address.");
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog("Missing Password", "Please enter your password.");
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupSuccess(name: "User")),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog("User Not Found", "No account found with this email.");
      } else if (e.code == 'wrong-password') {
        _showErrorDialog("Incorrect Password", "Please check your password and try again.");
      } else {
        _showErrorDialog("Login Error", e.message ?? "Something went wrong.");
      }
    } catch (e) {
      _showErrorDialog("Error", "An unexpected error occurred.");
    }
  }

  //Forgot Password Function
  Future<void> _forgotPassword() async {
    TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Password", style: TextStyle(color: Colors.blue)),
          content: TextField(
            controller: resetEmailController,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String resetEmail = resetEmailController.text.trim();
                if (resetEmail.isEmpty || !_isValidEmail(resetEmail)) {
                  _showErrorDialog("Invalid Email", "Please enter a valid email address.");
                  return;
                }

                try {
                  await _auth.sendPasswordResetEmail(email: resetEmail);
                  Navigator.pop(context);
                  _showSuccessDialog("Recovery Email Sent", "Check your inbox for password reset instructions.");
                } on FirebaseAuthException catch (e) {
                  _showErrorDialog("Reset Error", e.message ?? "Something went wrong.");
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
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
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
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
            Stack(
              children: [
                ClipPath(
                  child: Container(
                    height: 280,
                    color: const Color(0xFFA7C7E7),
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'PlayfairDisplay'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, spreadRadius: 2, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: 'PlayfairDisplay')),
                    const SizedBox(height: 20),

                    // Email Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.black54),
                          hintText: 'example@gmail.com',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _forgotPassword, child: const Text("Forgot Password?"))),

                    const SizedBox(height: 10),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _validateLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA7C7E7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Register())),
                      child: const Text("Don't have an account? REGISTER", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

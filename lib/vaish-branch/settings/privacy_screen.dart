import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Settings",
          style: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Your Privacy Matters",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sen',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "At FridgeFinds, we prioritize your privacy and the security of your personal information. Here's what we do to protect you:",
              style: TextStyle(fontSize: 16, fontFamily: 'Sen'),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.lock),
              title: Text(
                "Data Encryption",
                style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "All your personal and sensitive data is securely encrypted using the latest encryption technologies.",
                style: TextStyle(fontFamily: 'Sen'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.shield),
              title: Text(
                "Secure Connections",
                style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "We use secure connections (HTTPS and TLS) to ensure that your data remains private and protected while in transit.",
                style: TextStyle(fontFamily: 'Sen'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.data_usage),
              title: Text(
                "Data Collection",
                style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "We collect minimal data necessary to provide you with a personalized experience. We do not sell or share your personal data.",
                style: TextStyle(fontFamily: 'Sen'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.accessibility),
              title: Text(
                "User Rights",
                style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "You have full control over your data. You can request access to your data, update it, or delete it at any time.",
                style: TextStyle(fontFamily: 'Sen'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Third-Party Services",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sen',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We may use third-party services (like analytics or payment gateways), but rest assured that these services comply with the highest privacy standards. Please review their respective privacy policies for further details.",
              style: TextStyle(fontSize: 16, fontFamily: 'Sen'),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your Consent",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sen',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "By using the app, you consent to the collection and use of your information as described in this Privacy Policy. If you do not agree with this policy, please refrain from using our services.",
              style: TextStyle(fontSize: 16, fontFamily: 'Sen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to terms and conditions or other relevant screens
              },
              child: const Text(
                "Read Our Full Privacy Policy",
                style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

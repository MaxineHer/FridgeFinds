import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PersonalInfoPage(),
  ));
}

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Personal Info',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'PlayfairDisplay',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: Text(
              'EDIT',
              style: TextStyle(color: Color(0xFF6E86D0)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centering everything
          children: [
            // Profile Picture and Name
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF6E86D0),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Jane Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            SizedBox(height: 30),
            // Personal Info Fields (inside boxes)
            _buildInfoItem(Icons.person, 'FULL NAME', 'Jane Doe'),
            SizedBox(height: 16),
            _buildInfoItem(Icons.email, 'EMAIL', 'janedoe@gmail.com'),
            SizedBox(height: 16),
            _buildInfoItem(Icons.phone, 'PHONE NUMBER', '050-1234567'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String info) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF6E86D0), size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontFamily: 'Sen', // Using Sen font for text
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sen', // Using Sen font for information
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
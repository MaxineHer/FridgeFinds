import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help Center",
          style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center content
            crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center content
            children: [
              Text(
                "Contact us at: 04-1234567",
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(fontFamily: 'Sen', fontSize: 16),
              ),
              SizedBox(height: 8), // Add some spacing between the lines
              Text(
                "Or email us at support@fridgefinds.com",
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(fontFamily: 'Sen', fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

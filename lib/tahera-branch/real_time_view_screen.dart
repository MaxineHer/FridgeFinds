import 'package:flutter/material.dart';
import 'shelf_card.dart';
import 'expanded_shelf_screen.dart';
import 'tmain.dart'; // Import your custom BottomNavBar widget

class RealTimeViewScreen extends StatefulWidget {
  const RealTimeViewScreen({Key? key}) : super(key: key);

  @override
  State<RealTimeViewScreen> createState() => _RealTimeViewScreenState();
}

class _RealTimeViewScreenState extends State<RealTimeViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A light background color for the entire screen
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Real Time View',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro / instructions at the top
          Container(
            width: double.infinity,
            color: Colors.blue[50],
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Monitor your fridge shelves in real time. '
                  'Tap a shelf below to see the live camera feed.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),

          // A small "Fridge Connected" status row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

          ),

          // Expanded so the ListView fills remaining space
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // Top Shelf
                ShelfCard(
                  shelfName: 'Top Shelf',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExpandedShelfScreen(
                          shelfName: 'Top Shelf',
                          streamUrl: 'http://10.115.0.140:8081/picamera',
                        ),
                      ),
                    );
                  },
                ),
                // Middle Shelf
                ShelfCard(
                  shelfName: 'Middle Shelf',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExpandedShelfScreen(
                          shelfName: 'Middle Shelf',
                          streamUrl: 'http://10.115.0.140:8081/usbcamera1',
                        ),
                      ),
                    );
                  },
                ),
                // Bottom Shelf
                ShelfCard(
                  shelfName: 'Bottom Shelf',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExpandedShelfScreen(
                          shelfName: 'Bottom Shelf',
                          streamUrl: 'http://10.115.0.140:8081/usbcamera2',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
import 'package:flutter/material.dart';
import 'shelf_card.dart';
import 'expanded_shelf_screen.dart';
import 'main.dart'; // Import your custom BottomNavBar widget

class RealTimeViewScreen extends StatefulWidget {
  const RealTimeViewScreen({Key? key}) : super(key: key);

  @override
  State<RealTimeViewScreen> createState() => _RealTimeViewScreenState();
}

class _RealTimeViewScreenState extends State<RealTimeViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Updated AppBar
      appBar: AppBar(
        title: const Text(
          'Real Time View',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Aligns the title to the left
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Top Shelf
          ShelfCard(
            shelfName: 'Top Shelf',
            imageAssetPath: 'assets/images/top_shelf.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpandedShelfScreen(
                    shelfName: 'Top Shelf',
                    imageAssetPath: 'assets/images/top_shelf.png',
                  ),
                ),
              );
            },
          ),
          // Middle Shelf
          ShelfCard(
            shelfName: 'Middle Shelf',
            imageAssetPath: 'assets/images/middle_shelf.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpandedShelfScreen(
                    shelfName: 'Middle Shelf',
                    imageAssetPath: 'assets/images/middle_shelf.png',
                  ),
                ),
              );
            },
          ),
          // Bottom Shelf
          ShelfCard(
            shelfName: 'Bottom Shelf',
            imageAssetPath: 'assets/images/bottom_shelf.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpandedShelfScreen(
                    shelfName: 'Bottom Shelf',
                    imageAssetPath: 'assets/images/bottom_shelf.png',
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // Use your custom BottomNavBar to match other screens
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

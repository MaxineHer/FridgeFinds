import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'userprofile_page.dart';
import 'consumption_shopping_page.dart';
import 'package:fridge_finds/vaish-branch/grocery_list.dart';
import 'package:fridge_finds/vaish-branch/expiry_details.dart';
import 'package:fridge_finds/vaish-branch/inventory_tracking.dart';
import 'package:fridge_finds/tahera-branch/real_time_view_screen.dart';
import 'package:fridge_finds/tahera-branch/fridgecon1.dart';
import 'package:fridge_finds/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  FeatureItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });
}

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  List<FeatureItem> get allFeatures => [
    FeatureItem(
      icon: Icons.inventory,
      title: 'Fridge Items',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InventoryTrackingScreen(),
          ),
        );
      },
    ),
    FeatureItem(
      icon: Icons.timer,
      title: 'Expiry Tracking',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExpiryTrackingScreen(),
          ),
        );
      },
    ),
    FeatureItem(
      icon: Icons.wifi,
      title: 'Fridge Connectivity',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FridgeConnectivityScreen(),
          ),
        );
      },
    ),
    FeatureItem(
      icon: Icons.visibility,
      title: 'Fridge View',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RealTimeViewScreen(),
          ),
        );
      },
    ),
    FeatureItem(
      icon: Icons.list,
      title: 'Grocery Lists',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GroceryListScreen(),
          ),
        );
      },
    ),
    FeatureItem(
      icon: Icons.shopping_cart,
      title: 'Consumption & Smart List',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConsumptionScreen(),
          ),
        );
      },
    ),
  ];

  List<FeatureItem> get filteredFeatures {
    if (searchQuery.isEmpty) {
      return allFeatures;
    } else {
      return allFeatures
          .where((item) =>
          item.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double extraPadding = MediaQuery.of(context).padding.bottom + 30;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(bottom: extraPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeader(userName: widget.userName),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBar(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications,
                            size: 36,
                            color: Color(0xFF355599),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  FeatureGrid(features: filteredFeatures),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class WelcomeHeader extends StatelessWidget {
  final String userName;

  const WelcomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: 'Welcome\n'),
                TextSpan(
                  text: 'Jane Doe',
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    color: Color(0xFF335ACE),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Where smart fridge management meets personalized convenience!',
            style: TextStyle(
              fontFamily: 'Sen',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: const Color(0xFF355599)),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  final List<FeatureItem> features;

  const FeatureGrid({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 12;
    final double spacing = 15;
    final double totalWidth =
        MediaQuery.of(context).size.width - (2 * horizontalPadding);
    final double cellWidth = (totalWidth - spacing) / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: spacing,
        runSpacing: 23,
        children: features.map((feature) {
          return SizedBox(
            width: cellWidth,
            child: FeatureCard(
              icon: feature.icon,
              title: feature.title,
              onTap: feature.onTap,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? color;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Fixed height for uniform size and gap above navigation
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFCDE1F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: const Color(0xFF355599)),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                style: const TextStyle(
                  fontFamily: 'Sen',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF6E86D0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // Navigate to home
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroceryListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.list, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPage(),
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
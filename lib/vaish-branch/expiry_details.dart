import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fridge_finds/vaish-branch/grocery_list.dart';
import 'package:fridge_finds/manasvi-branch/userprofile_page.dart';
import 'package:fridge_finds/manasvi-branch/home_page.dart';

const String serverIP = "http://10.115.0.140";
const String scannerIP = "http://10.155.0.55";

class FridgeItem {
  String name;
  int quantity;
  String barcode;
  String expiryDate;

  FridgeItem({
    required this.name,
    required this.quantity,
    required this.barcode,
    this.expiryDate = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
      'expiryDate': expiryDate,
    };
  }

  // Calculate the days to expire from today's date
  int get daysToExpire {
    if (expiryDate.isEmpty) return -1; // If expiry date is not set, return -1
    DateTime expiry = DateTime.parse(expiryDate);
    DateTime today = DateTime.now();
    return expiry.difference(today).inDays;
  }
}

class ExpiryTrackingScreen extends StatefulWidget {
  const ExpiryTrackingScreen({Key? key}) : super(key: key);

  @override
  _ExpiryTrackingScreenState createState() => _ExpiryTrackingScreenState();
}

class _ExpiryTrackingScreenState extends State<ExpiryTrackingScreen> {
  List<FridgeItem> fridgeItems = [];
  bool isLoading = true;
  List<FridgeItem> filteredItems = [];
  String searchQuery = '';

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _fetchItemsFromServer() async {
    try {
      final response = await http.get(Uri.parse(
          '$serverIP/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQX'
              'Oj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up&get=ItemInfoAll'));

      if (response.statusCode == 200) {
        List<dynamic> items = jsonDecode(response.body);
        setState(() {
          fridgeItems = items.map((item) {
            return FridgeItem(
              name: item['itemName'] ?? 'Unknown',
              quantity: int.tryParse(item['itemQuantity'].toString()) ?? 0,
              barcode: item['barcode'] ?? '',
              expiryDate: item['expiryDate'] ?? "",
            );
          }).toList();

          // Filter out items with quantity 0
          fridgeItems = fridgeItems.where((item) => item.quantity > 0).toList();

          // Sort items by expiry date (empty expiry dates go last)
          fridgeItems.sort((a, b) =>
              (a.expiryDate.isNotEmpty ? a.expiryDate : "9999-12-31")
                  .compareTo(b.expiryDate.isNotEmpty ? b.expiryDate : "9999-12-31"));

          filteredItems = List.from(fridgeItems);
          isLoading = false;
        });
      } else {
        _showErrorMessage("Failed to fetch data. Please try again.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showErrorMessage("Error fetching items. Please check your network.");
      setState(() => isLoading = false);
    }
  }

  // Scan the expiry date (activates the fridge camera, not the phone camera)
  Future<void> _scanExpiryDate(int index) async {
    try {
      await http.get(Uri.parse('$scannerIP/scan_expiry'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Scanning expiry date...")),
      );
      await Future.delayed(const Duration(seconds: 5));

      // Simulated expiry date (Replace this with real scanning logic)
      String scannedExpiryDate = "2025-12-31";
      setState(() {
        fridgeItems[index].expiryDate = scannedExpiryDate;
      });

      // Store updated item in Firestore
      await FirebaseFirestore.instance
          .collection('fridge_inventory')
          .doc(fridgeItems[index].barcode)
          .set(fridgeItems[index].toJson());
    } catch (e) {
      _showErrorMessage("Error scanning expiry date.");
    }
  }

  void _filterItems(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = fridgeItems.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchItemsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expiry Tracking",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Inventory...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (query) => _filterItems(query),
            ),
          ),

          // Clarification text about the camera icon
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 2.0),
            child: Text(
              "Note: Tapping the camera icon will activate the fridge's camera.",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ),

          // List of items
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];

                // Determine the icon and color based on expiry
                late Color iconColor;
                late IconData expiryIcon;
                late String expiryText;

                if (item.daysToExpire == 0) {
                  iconColor = Colors.red;
                  expiryText = "Expires: Today!";
                  expiryIcon = Icons.error;
                } else if (item.daysToExpire > 0 && item.daysToExpire <= 2) {
                  iconColor = Colors.orange;
                  expiryText = "Expires in: ${item.daysToExpire} days";
                  expiryIcon = Icons.sentiment_dissatisfied;
                } else if (item.daysToExpire > 2) {
                  iconColor = Colors.green;
                  expiryText = "Expires in: ${item.daysToExpire} days";
                  expiryIcon = Icons.thumb_up;
                } else {
                  // daysToExpire < 0 or no expiry date
                  // We'll treat it as expired or unknown
                  iconColor = Colors.red;
                  expiryText = "Expires in: -1 days"; // or "Unknown"
                  expiryIcon = Icons.error;
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.daysToExpire <= 0
                          ? Colors.red[50]
                          : item.daysToExpire <= 2
                          ? Colors.orange[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // We build a custom row so icons are center-aligned
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left side: name, quantity, and expiry info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: ${item.quantity}',
                                  style: const TextStyle(fontFamily: 'Roboto'),
                                ),
                                const SizedBox(height: 4),
                                // A row for the expiry text and icon
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      expiryText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Sen',
                                        fontWeight: FontWeight.normal,
                                        color: iconColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      expiryIcon,
                                      color: iconColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Right side: camera icon
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Color(0xFF355599),
                            ),
                            onPressed: () => _scanExpiryDate(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(userName: 'User'),
                ),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
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
              Navigator.pushReplacement(
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

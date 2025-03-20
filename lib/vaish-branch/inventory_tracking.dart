import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fridge_finds/manasvi-branch/home_page.dart';
import 'package:fridge_finds/manasvi-branch/userprofile_page.dart';
import 'grocery_list.dart';
import 'package:fridge_finds/main.dart';
import 'mjpegscreen.dart';

// Server IP Configuration
const String serverIP = "http://10.115.0.140";
const String scannerIP = "http://10.155.0.140";

// Model for a Fridge Item
class FridgeItem {
  String name;
  int quantity;
  String barcode;

  FridgeItem({required this.name, required this.quantity, required this.barcode});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
    };
  }
}

class InventoryTrackingScreen extends StatefulWidget {
  const InventoryTrackingScreen({Key? key}) : super(key: key);

  @override
  _InventoryTrackingScreenState createState() => _InventoryTrackingScreenState();
}

class _InventoryTrackingScreenState extends State<InventoryTrackingScreen> {
  List<FridgeItem> fridgeItems = [];
  String searchQuery = '';
  bool isLoading = true;

  // Show error message
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
          fridgeItems = items
              .map((item) => FridgeItem(
            name: item['itemName'] ?? 'Unknown',
            quantity: int.tryParse(item['itemQuantity'].toString()) ?? 0,
            barcode: item['barcode'] ?? '',
          ))
              .where((item) => item.quantity > 0) // Filter out items with quantity zero
              .toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch data: ${response.statusCode}");
        _showErrorMessage("Failed to fetch data. Please try again.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching items: $e");
      _showErrorMessage("Error fetching items. Please check your network.");
      setState(() => isLoading = false);
    }
  }

  // Increment quantity for an item and update the server
  Future<void> _incrementQuantity(int index) async {
    final item = fridgeItems[index];
    final newQuantity = item.quantity + 1;

    try {
      final response = await http.post(
        Uri.parse(
            '$serverIP/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up&update=ItemInfoIncrease'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'barcode': item.barcode, 'itemQuantity': 1}),
      );

      if (response.statusCode == 200) {
        setState(() {
          fridgeItems[index].quantity = newQuantity;
        });
      } else {
        _showErrorMessage("Failed to update quantity.");
      }
    } catch (e) {
      _showErrorMessage("Error updating item quantity.");
    }
  }

  // Decrement quantity for an item and update the server
  Future<void> _decrementQuantity(int index) async {
    final item = fridgeItems[index];
    if (item.quantity > 0) {
      final newQuantity = item.quantity - 1;

      try {
        final response = await http.post(
          Uri.parse(
              '$serverIP/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up&update=ItemInfoDecrease'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'barcode': item.barcode, 'itemQuantity': 1}),
        );

        if (response.statusCode == 200) {
          setState(() {
            fridgeItems[index].quantity = newQuantity;
            if (newQuantity == 0) {
              fridgeItems.removeAt(index); // Remove item from list if quantity is zero
            }
          });
        } else {
          _showErrorMessage("Failed to update quantity.");
        }
      } catch (e) {
        _showErrorMessage("Error updating item quantity.");
      }
    }
  }

  // Scan a new item (activates the fridge camera, not the phone camera)
  Future<void> _scanNewItem() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MjpegCameraScreen()),
    );
  }




  @override
  void initState() {
    super.initState();
    _fetchItemsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = fridgeItems.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fridge Items",
            style: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold, fontSize: 30)),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),

          // Clarification text about the camera
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 2.0),
            child: Text(
              "Note: Tapping the camera icon below will activate the fridge's camera.",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ),

          // List of items
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
              child: Text(
                "Try scanning new items to see what's in your fridge!",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                // Get the original index of the item in the full fridgeItems list
                final originalIndex = fridgeItems
                    .indexWhere((element) => element.barcode == item.barcode);
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Quantity: ${item.quantity}',
                      style:
                      const TextStyle(fontFamily: 'Roboto'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () =>
                              _decrementQuantity(originalIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Colors.green),
                          onPressed: () =>
                              _incrementQuantity(originalIndex),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanNewItem,
        backgroundColor: const Color(0xFF355599),
        child: const Icon(Icons.camera_alt, color: Colors.white),
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
                    builder: (context) => const HomeScreen(userName: 'User')),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GroceryListScreen()),
              );
            },
            icon: const Icon(Icons.list, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserPage()),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}

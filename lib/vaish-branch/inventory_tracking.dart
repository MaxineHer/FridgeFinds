import 'package:flutter/material.dart';
import 'package:fridge_finds/consumption_shopping_page.dart';
import 'package:fridge_finds/home_page.dart';
import 'package:fridge_finds/userprofile_page.dart';
import 'grocery_list.dart';

// Model for a Fridge Item
class FridgeItem {
  final String name;
  final int quantity;

  FridgeItem({required this.name, required this.quantity});
}

class InventoryTrackingScreen extends StatefulWidget {
  const InventoryTrackingScreen({Key? key}) : super(key: key);

  @override
  _InventoryTrackingScreenState createState() => _InventoryTrackingScreenState();
}

class _InventoryTrackingScreenState extends State<InventoryTrackingScreen> {
  List<FridgeItem> fridgeItems = [
    FridgeItem(name: 'Tomatoes', quantity: 10),
    FridgeItem(name: 'Cucumbers', quantity: 5),
    FridgeItem(name: 'Milk', quantity: 2),
    FridgeItem(name: 'Eggs', quantity: 12),
    FridgeItem(name: 'Bread', quantity: 2),
    FridgeItem(name: 'Orange Juice', quantity: 1),
    FridgeItem(name: 'Capsicum', quantity: 3),
    FridgeItem(name: 'Yoghurt', quantity: 1),
    FridgeItem(name: 'Beans', quantity: 15),
    FridgeItem(name: 'Cabbage', quantity: 1),
    FridgeItem(name: 'Lettuce', quantity: 1),
    FridgeItem(name: 'Mint', quantity: 5),
    FridgeItem(name: 'Carrot', quantity: 7),
    FridgeItem(name: 'Broccoli', quantity: 2),
  ];

  String searchQuery = '';
  int _selectedIndex = 0;

  void _addToGroceryList(FridgeItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to grocery list')),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on the selected index
    // Add your screen transitions here if needed
  }

  //void _navigateToConsumptionPattern() {
    // You can replace this with actual navigation code once the consumption pattern page is created
    //Navigator.push(
    //  context,
   //   MaterialPageRoute(builder: (context) => ConsumptionPatternScreen()),
 //   );
 // }

  @override
  Widget build(BuildContext context) {
    // Filter the fridge items based on the search query
    List<FridgeItem> filteredItems = fridgeItems
        .where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Tracking", style: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
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
          // "Show Consumption Pattern" Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsumptionScreen(),
                  ),
                );
              },
              child: Text(
                "Show Consumption Pattern",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          // Inventory List
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(item.name, style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                    subtitle: Text('Quantity: ${item.quantity}', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addToGroceryList(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

// Placeholder for Consumption Pattern Screen
//class ConsumptionPatternScreen extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
    //return Scaffold(
      //appBar: AppBar(title: Text("Consumption Pattern")),
      //body: Center(
        //child: Text("Consumption Pattern Data will be shown here"),
      //),
    //);
  //}
//}

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
                  builder: (context) =>
                  const HomeScreen(userName: 'User'), // Home screen page
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


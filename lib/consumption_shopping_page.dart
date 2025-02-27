import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'home_page.dart';
import 'userprofile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ConsumptionScreen(),
    );
  }
}

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  ConsumptionScreenState createState() => ConsumptionScreenState();
}

class ConsumptionScreenState extends State<ConsumptionScreen> {
  // Simulating inventory status of various food items (tracked by cameras)
  final Map<String, double> inventoryStatus = {
    "Bread": 80,
    "Yogurt": 50,
    "Milk": 60,
    "Chicken": 40,
    "Apple": 30,
    "Cheese": 20,
    "Carrots": 10,
    "Fish": 20,
    "Garlic": 20,
    "Biscuit": 10
  };

  // Data mapping food categories based on the consumption pattern (categories are calculated)
  Map<String, double> dataMap = {
    "Vegetables": 30,
    "Fruits": 20,
    "Dairy": 10,
    "Meat": 5,
    "Seafood": 5,
    "Bakery": 10,
    "Random Foods": 20,
  };

  // Define shopping list for food items
  final Set<String> shoppingList = {};

  // New blank list for user customization
  final Set<String> customList = {};

  // Update consumption data based on inventory status (food categories)
  void updateConsumptionData() {
    setState(() {
      // Categorize food items into their respective categories
      dataMap = {
        "Vegetables": (inventoryStatus["Carrots"]! + inventoryStatus["Garlic"]!) / 2, // Average inventory percentage for vegetables
        "Fruits": inventoryStatus["Apple"]!, // Example - apples are categorized as fruits
        "Dairy": (inventoryStatus["Milk"]! + inventoryStatus["Yogurt"]!)/2, // Example - milk falls under dairy
        "Meat": inventoryStatus["Chicken"]!, // Example - chicken is categorized as meat
        "Seafood": inventoryStatus["Fish"]!, // Placeholder for seafood
        "Bakery": inventoryStatus["Bread"]!, // Example - bread as bakery
        "Random Foods": inventoryStatus["Biscuit"]!, // Example - biscuit as random foods
      };
    });
  }

  // Automatically generate the shopping list based on low inventory items
  void generateShoppingList() {
    setState(() {
      shoppingList.clear(); // Clear previous items in the main shopping list

      inventoryStatus.forEach((foodItem, inventoryPercentage) {
        if (inventoryPercentage < 40) {
          // Add items with less than 40% inventory to the shopping list
          shoppingList.add(foodItem);
        }
      });
    });
  }

  // Add item to custom list
  void addToCustomList(String item) {
    setState(() {
      customList.add(item); // Add to custom list
      shoppingList.remove(item); // Optionally remove it from shopping list
    });
  }

  @override
  void initState() {
    super.initState();
    updateConsumptionData(); // Initialize data when screen loads
    generateShoppingList(); // Automatically generate shopping list based on inventory status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Consumption Pattern", style: TextStyle(fontFamily: 'PlayfairDisplay')),
        backgroundColor: Colors.transparent, // Remove background color for the AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView( // Add scroll view to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pie Chart for Monthly Consumption Pattern based on inventory status
              SizedBox(
                width: double.infinity,
                height: 250, // Reduced size for the Pie Chart
                child: PieChart(
                  dataMap: dataMap,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 15, // Slightly thinner ring
                  chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
                  legendOptions: const LegendOptions(showLegends: true,
                      legendPosition: LegendPosition.right,
                      legendTextStyle: TextStyle(fontFamily: 'Sen')),
                  colorList: [
                    Colors.green, // Vegetables
                    Colors.red, // Fruits
                    Colors.yellow, // Dairy
                    Colors.pink.shade900, // Meat
                    Colors.blue, // Seafood
                    Colors.brown.shade400, // Bakery
                    Colors.black, // Random Foods
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Smart Shopping List section (showing actual food items for suggestions)
              _buildSmartShoppingList(),

              const SizedBox(height: 30),

              // List Created section (Single grocery list showing food items)
              _buildGroceryList(),

              const SizedBox(height: 30),

              // New Blank List for the user to add items
              _buildCustomList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  // Smart Shopping List Section (updated with actual food items for each category)
  Widget _buildSmartShoppingList() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Smart Shopping List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'PlayfairDisplay'),
            ),
            const SizedBox(height: 10),
            const Text(
              "Suggestions based on your consumption pattern",
              style: TextStyle(fontSize: 14, color: Colors.blue, fontFamily: 'Sen'),
            ),
            const SizedBox(height: 20),
            // Loop through each food item and display them
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: inventoryStatus.keys.map((item) {
                return Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () => addToCustomList(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make the button background transparent
                      shadowColor: Colors.transparent, // Remove button shadow
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Sen'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Grocery List Section (only showing food items added to the shopping list)
  Widget _buildGroceryList() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "List Created",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'PlayfairDisplay'),
            ),
            const SizedBox(height: 10),
            // Display the grocery list with checkmarks
            Wrap(
              spacing: 10,
              children: shoppingList.map((item) {
                return Chip(
                  label: Text(item,
                    style: const TextStyle(fontFamily: 'Sen'),
                  ),
                  backgroundColor: Colors.blue[100],
                  deleteIcon: const Icon(Icons.delete, size: 18),
                  onDeleted: () => toggleItem(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // If no items in the list
            if (shoppingList.isEmpty)
              const Text(
                "No items added to your list yet.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  // Custom List Section (for adding items from suggestions)
  Widget _buildCustomList() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Custom List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'PlayfairDisplay'),
            ),
            const SizedBox(height: 10),
            // Display the custom list with checkmarks
            Wrap(
              spacing: 10,
              children: customList.map((item) {
                return Chip(
                  label: Text(item,
                    style: const TextStyle(fontFamily: 'Sen'),
                  ),
                  backgroundColor: Colors.blue[100],
                  deleteIcon: const Icon(Icons.delete, size: 18),
                  onDeleted: () {
                    setState(() {
                      customList.remove(item); // Remove item from the custom list
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // If no items in the list
            if (customList.isEmpty)
              const Text(
                "No items added to your custom list yet.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontFamily: 'Sen'),
              ),
          ],
        ),
      ),
    );
  }

  // Toggle item in the grocery list
  void toggleItem(String item) {
    setState(() {
      if (shoppingList.contains(item)) {
        shoppingList.remove(item);
      } else {
        shoppingList.add(item);
      }
    });
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
          // Home icon navigates back to HomeScreen
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(userName: 'User'), // Home screen page
                ),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              // Navigate to grocery lists
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

//HELLO WORLD OF FRIDGEFINDS
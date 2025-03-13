import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'home_page.dart';
import 'userprofile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, double> dataMap = {}; // Pie chart data
  final String raspberryPiUrl = "http://10.115.0.55/api/index.php?operation=consumption_data"; // API URL

  final Set<String> shoppingList = {}; // Smart Shopping List

  @override
  void initState() {
    super.initState();
    fetchConsumptionData(); // Fetch data from Raspberry Pi
  }

  // Fetch monthly consumption from Raspberry Pi
  Future<void> fetchConsumptionData() async {
    try {
      final response = await http.get(Uri.parse(raspberryPiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> consumptionData = json.decode(response.body);

        // Convert data for Pie Chart
        setState(() {
          dataMap = {
            "Vegetables": consumptionData["Vegetables"].toDouble(),
            "Fruits": consumptionData["Fruits"].toDouble(),
            "Dairy": consumptionData["Dairy"].toDouble(),
            "Bakery": consumptionData["Bakery"].toDouble(),
            "Random Foods": consumptionData["Random"].toDouble(),
          };
        });

        // Generate Smart Shopping List based on low inventory
        generateShoppingList(consumptionData);

        // Store data in Firebase
        await _firestore.collection("monthly_consumption").doc("March2025").set(dataMap);
      } else {
        print("Error fetching data from Raspberry Pi");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // Generate Smart Shopping List based on low consumption
  void generateShoppingList(Map<String, dynamic> consumptionData) {
    setState(() {
      shoppingList.clear();
      consumptionData.forEach((foodItem, quantity) {
        if (quantity < 40) {
          shoppingList.add(foodItem);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Consumption Pattern"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pie Chart - Monthly Consumption Pattern
            SizedBox(
              height: 250,
              child: PieChart(
                dataMap: dataMap.isNotEmpty ? dataMap : {"Loading...": 100},
                chartType: ChartType.ring,
                ringStrokeWidth: 15,
                chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
                legendOptions: const LegendOptions(showLegends: true, legendPosition: LegendPosition.right),
              ),
            ),
            const SizedBox(height: 30),

            // Smart Shopping List Section
            _buildSmartShoppingList(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(), // Keeping your Bottom Navigation the same
    );
  }

  // Smart Shopping List Section
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Items running low based on consumption data",
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: shoppingList.map((item) {
                return Chip(
                  label: Text(item, style: const TextStyle(fontSize: 14)),
                  backgroundColor: Colors.blue[100],
                  deleteIcon: const Icon(Icons.delete, size: 18),
                  onDeleted: () => removeFromShoppingList(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            if (shoppingList.isEmpty)
              const Text(
                "No items to buy. Your inventory is sufficient.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  // Remove item from the shopping list
  void removeFromShoppingList(String item) {
    setState(() {
      shoppingList.remove(item);
    });
  }
}

// Bottom Navigation (Same as before)
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
                  builder: (context) =>
                  const HomeScreen(userName: 'User'), // Home screen page
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

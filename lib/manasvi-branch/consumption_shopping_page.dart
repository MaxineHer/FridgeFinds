import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'home_page.dart';
import 'userprofile_page.dart';


class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  ConsumptionScreenState createState() => ConsumptionScreenState();
}

class ConsumptionScreenState extends State<ConsumptionScreen> {
  Map<String, double> dataMap = {}; // Pie chart data
  final String apiUrl = "http://10.115.0.140/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up";

  List<String> shoppingList = []; // Smart Shopping List

  @override
  void initState() {
    super.initState();
    fetchItemCategoryPercentages();
    generateShoppingList(); //  Fetch Smart Shopping List from API
  }

  Future<void> fetchItemCategoryPercentages() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl&get=ItemCategoryPercentagesOutside"));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        Map<String, double> parsedData = {};

        for (var item in decodedResponse) {
          if (item is Map<String, dynamic> && item.containsKey("itemCategory") && item.containsKey("categoryPercentage")) {
            String categoryName = item["itemCategory"].toString().replaceAll("en:", "");
            parsedData[categoryName] = double.tryParse(item["categoryPercentage"].toString()) ?? 0.0;
          }
        }

        setState(() {
          dataMap = parsedData;
        });
      } else {
        print("❌ API Call Failed! Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
  }

  Future<void> generateShoppingList() async {
    final String requestUrl = "$apiUrl&get=GenerateList";

    try {
      print("📢 Fetching Smart Shopping List from API: $requestUrl");
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        String responseBody = response.body.trim();

        //  Print the raw response for debugging
        print("📥 Raw API Response: $responseBody");

        //  Extract only the shopping list portion
        int splitIndex = responseBody.indexOf("][[");
        if (splitIndex != -1) {
          responseBody = responseBody.substring(splitIndex + 1).trim(); // Extract shopping list
        }

        //  Replace single quotes with double quotes to fix JSON decoding
        responseBody = responseBody.replaceAll("'", "\"");

        //  Ensure the response is correctly formatted
        while (responseBody.startsWith("[[") && responseBody.endsWith("]]")) {
          responseBody = responseBody.substring(1, responseBody.length - 1);
        }

        //  Decode JSON safely
        dynamic responseData;
        try {
          responseData = json.decode(responseBody);
          print("✅ Decoded JSON Successfully!");
        } catch (e) {
          print("❌ JSON Decode Error: $e");
          return;
        }

        List<String> extractedItems = [];

        // Process only items with `itemQuantity == 0`
        if (responseData is List) {
          for (var element in responseData) {
            if (element is List) {
              for (var subElement in element) {
                if (subElement is Map<String, dynamic> &&
                    subElement.containsKey('itemName') &&
                    subElement.containsKey('itemQuantity')) {
                  int quantity = int.tryParse(subElement['itemQuantity'].toString()) ?? -1;
                  print("🔍 Found Item: ${subElement['itemName']} - Quantity: $quantity");
                  if (quantity == 0) {
                    extractedItems.add(subElement['itemName'].toString());
                  }
                }
              }
            }
          }
        } else {
          print("⚠️ API Response is not a list! Type: ${responseData.runtimeType}");
          return;
        }

        //  Update UI with extracted items
        setState(() {
          shoppingList = extractedItems;
        });

        print("📌 Final Shopping List: $shoppingList");
      } else {
        print("❌ Error: Failed to fetch shopping list. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching Smart Shopping List: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Monthly Consumption Pattern",
          style: TextStyle(fontFamily: 'PlayfairDisplay'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            _buildSmartShoppingList(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildSmartShoppingList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Smart Shopping List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Items running low based on consumption data", style: TextStyle(fontSize: 14, color: Colors.blue)),
            const SizedBox(height: 20),
            if (shoppingList.isEmpty)
              const Text("No items to buy. Your inventory is sufficient.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
            else
              Column(
                children: shoppingList.map((item) {
                  return ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
          ],
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(userName: 'User')));
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.list, color: Colors.white, size: 32)),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserPage()));
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
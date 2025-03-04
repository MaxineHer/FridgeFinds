import 'package:flutter/material.dart';

// Model for an expiry item
class ExpiryItem {
  final String name;
  final int daysToExpire;

  ExpiryItem({required this.name, required this.daysToExpire});
}

class ExpiryDetailsScreen extends StatefulWidget {
  const ExpiryDetailsScreen({Key? key}) : super(key: key);

  @override
  _ExpiryDetailsScreenState createState() => _ExpiryDetailsScreenState();
}

class _ExpiryDetailsScreenState extends State<ExpiryDetailsScreen> {
  int _selectedIndex = 0; // Track the selected index

  List<ExpiryItem> expiryItems = [
    ExpiryItem(name: 'Bread', daysToExpire: 0),
    ExpiryItem(name: 'Milk', daysToExpire: 2),
    ExpiryItem(name: 'Yoghurt', daysToExpire: 4),
    ExpiryItem(name: 'Frozen Waffles', daysToExpire: 7),
    ExpiryItem(name: 'Apple Juice', daysToExpire: 13),
  ];

  String searchQuery = '';

  // Determines the expiry text and icon
  Widget getExpiryDetails(ExpiryItem item) {
    ThemeData theme = Theme.of(context);
    Color textColor = theme.textTheme.bodyLarge!.color!;
    Color iconColor;

    if (item.daysToExpire == 0) {
      iconColor = Colors.red;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, fontFamily: 'Sen', fontWeight: FontWeight.normal),
              children: [
                TextSpan(text: "Expires: ", style: TextStyle(color: textColor)),
                TextSpan(text: "Today!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(Icons.error, color: iconColor),
        ],
      );
    } else if (item.daysToExpire <= 2) {
      iconColor = Colors.orange;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, fontFamily: 'Sen', fontWeight: FontWeight.normal),
              children: [
                TextSpan(text: "Expires in: ", style: TextStyle(color: textColor)),
                TextSpan(text: "${item.daysToExpire} days", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(Icons.sentiment_dissatisfied, color: iconColor),
        ],
      );
    } else {
      iconColor = Colors.green;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, fontFamily: 'Sen', fontWeight: FontWeight.normal),
              children: [
                TextSpan(text: "Expires in: ", style: TextStyle(color: textColor)),
                TextSpan(text: "${item.daysToExpire} days", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(Icons.thumb_up, color: iconColor),
        ],
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ExpiryItem> filteredItems = expiryItems
        .where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Get current theme to adjust styles accordingly
    ThemeData theme = Theme.of(context);
    Color backgroundColor = theme.scaffoldBackgroundColor;
    Color primaryTextColor = theme.textTheme.bodyLarge!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expiry Details", style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
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
                prefixIcon: Icon(Icons.search, color: primaryTextColor),
                hintText: 'Search for Food',
                hintStyle: TextStyle(color: primaryTextColor.withOpacity(0.6)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          // Expiry List
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: theme.cardColor,
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Sen',
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    subtitle: getExpiryDetails(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar with rounded corners and increased icon size
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 40, color: theme.bottomAppBarTheme.color),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 40, color: theme.bottomAppBarTheme.color),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40, color: theme.bottomAppBarTheme.color),
              label: "",
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Color(0xFF6E86D0),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
//test
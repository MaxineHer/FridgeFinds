import 'package:flutter/material.dart';
import 'list_screen.dart';// Import the ListDetailScreen
import 'package:fridge_finds/home_page.dart';
import 'package:fridge_finds/userprofile_page.dart';

class GroceryList {
  final String name;
  final DateTime createdAt;

  GroceryList({required this.name, required this.createdAt});
}

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryList> personalLists = [
    GroceryList(name: 'Weekly Groceries', createdAt: DateTime.now().subtract(Duration(days: 1))),
    GroceryList(name: 'Birthday Party', createdAt: DateTime.now().subtract(Duration(days: 3))),
  ];

  List<GroceryList> collaborativeLists = [
    GroceryList(name: 'Guest Dinner', createdAt: DateTime.now().subtract(Duration(days: 2))),
    GroceryList(name: 'Family Picnic', createdAt: DateTime.now().subtract(Duration(days: 5))),
  ];

  TextEditingController searchController = TextEditingController();
  TextEditingController listNameController = TextEditingController();
  String searchQuery = "";

  int _selectedIndex = 0;

  void _addNewList(bool isCollaborative) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New List"),
          content: TextField(
            controller: listNameController,
            decoration: InputDecoration(hintText: "Enter list name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (listNameController.text.isNotEmpty) {
                  setState(() {
                    final newList = GroceryList(name: listNameController.text, createdAt: DateTime.now());
                    if (isCollaborative) {
                      collaborativeLists.add(newList);
                    } else {
                      personalLists.add(newList);
                    }
                  });
                  listNameController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _openListDetail(GroceryList list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListDetailScreen(listName: list.name, createdAt: list.createdAt),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<GroceryList> filteredPersonalLists = personalLists
        .where((list) => list.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    List<GroceryList> filteredCollaborativeLists = collaborativeLists
        .where((list) => list.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Check if the app is in dark mode or light mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Lists', style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for List',
                hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54), // Adjust hint text color
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color
              onChanged: (query) {
                setState(() => searchQuery = query);
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildListSection("Personal Lists", filteredPersonalLists, false, isDarkMode),
                _buildListSection("Collaborative Lists", filteredCollaborativeLists, true, isDarkMode),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildListSection(String title, List<GroceryList> lists, bool isCollaborative, bool isDarkMode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                IconButton(
                  icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: () => _addNewList(isCollaborative),
                ),
              ],
            ),
          ),
          Expanded(
            child: lists.isEmpty
                ? Center(child: Text("No $title available", style: TextStyle(color: isDarkMode ? Colors.black : Colors.black)))
                : ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                return Card(
                  color: Color(0xFFCDE1F5), // Set the list item color
                  child: ListTile(
                    title: Text(list.name, style: TextStyle(color: isDarkMode ? Colors.black : Colors.black)),
                    subtitle: Text("Created on: ${list.createdAt.day}/${list.createdAt.month}/${list.createdAt.year}",
                        style: TextStyle(color: isDarkMode ? Colors.black : Colors.black)),
                    onTap: () => _openListDetail(list),
                  ),
                );
              },
            ),
          ),
        ],
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


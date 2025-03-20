import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'list_screen.dart';
import 'package:fridge_finds/manasvi-branch/home_page.dart';
import 'package:fridge_finds/manasvi-branch/userprofile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  TextEditingController listNameController = TextEditingController();
  String searchQuery = "";

  int _selectedIndex = 0;

  void _deleteList(String listId) async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      await _firestore.collection('grocery_lists').doc(listId).delete();
      setState(() {}); // Refresh UI
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Grocery List?"),
        content: Text("Are you sure you want to delete this grocery list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _addNewList() {
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
              onPressed: () async {
                if (listNameController.text.isNotEmpty) {
                  await _firestore.collection('grocery_lists').add({
                    'name': listNameController.text,
                    'createdAt': Timestamp.fromDate(DateTime.now()),
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

  void _openListDetail(String listId, String listName, DateTime createdAt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListDetailScreen(listId: listId, listName: listName, createdAt: createdAt),
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grocery Lists',
          style: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold, fontSize: 30),
        ),
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
                hintStyle: TextStyle(fontFamily: 'Sen', color: isDarkMode ? Colors.white54 : Colors.black54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              style: TextStyle(fontFamily: 'Sen', color: isDarkMode ? Colors.white : Colors.black),
              onChanged: (query) {
                setState(() => searchQuery = query);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('grocery_lists').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var filteredLists = snapshot.data!.docs
                    .where((doc) => doc['name'].toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                return _buildListSection("Personal Lists", filteredLists, isDarkMode);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildListSection(String title, List<QueryDocumentSnapshot> docs, bool isDarkMode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: _addNewList,
                ),
              ],
            ),
          ),
          Expanded(
            child: docs.isEmpty
                ? Center(
              child: Text(
                "No $title available",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            )
                : ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final list = doc.data() as Map<String, dynamic>;

                return Card(
                  color: Color(0xFFCDE1F5), // Set the list item color
                  child: ListTile(
                    title: Text(
                      list['name'],
                      style: TextStyle(fontFamily: 'Sen', color: Colors.black),
                    ),
                    subtitle: Text(
                      "Created on: ${list['createdAt'].toDate().day}/${list['createdAt'].toDate().month}/${list['createdAt'].toDate().year}",
                      style: TextStyle(fontFamily: 'Sen', color: Colors.black),
                    ),
                    onTap: () => _openListDetail(doc.id, list['name'], list['createdAt'].toDate()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteList(doc.id), //  Corrected deletion logic
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
                MaterialPageRoute(builder: (context) => const HomeScreen(userName: 'User')),
              );
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

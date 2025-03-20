import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListDetailScreen extends StatefulWidget {
  final String listId;
  final String listName;
  final DateTime createdAt;

  const ListDetailScreen({
    Key? key,
    required this.listId,
    required this.listName,
    required this.createdAt,
  }) : super(key: key);

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> items = []; // Stores items locally
  TextEditingController itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final docSnapshot =
    await _firestore.collection('grocery_lists').doc(widget.listId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        items = List<Map<String, dynamic>>.from(data?['items'] ?? []);
      });
    }
  }

  void _addItem() async {
    if (itemController.text.isNotEmpty) {
      items.add({'name': itemController.text, 'isChecked': false});

      await _firestore.collection('grocery_lists').doc(widget.listId).set({
        'name': widget.listName,
        // Store createdAt as a Timestamp rather than a String:
        'createdAt': Timestamp.fromDate(widget.createdAt),
        'items': items,
      });

      itemController.clear();
      setState(() {});
    }
  }

  void _toggleItem(int index) async {
    setState(() {
      items[index]['isChecked'] = !items[index]['isChecked'];
    });

    await _firestore
        .collection('grocery_lists')
        .doc(widget.listId)
        .update({'items': items});
  }

  void _deleteItem(int index) async {
    setState(() {
      items.removeAt(index);
    });

    await _firestore
        .collection('grocery_lists')
        .doc(widget.listId)
        .update({'items': items});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          widget.listName,
          style: TextStyle(
              color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Created on: ${widget.createdAt.day}/${widget.createdAt.month}/${widget.createdAt.year}",
              style: TextStyle(
                  fontFamily: 'Sen', fontSize: 14, color: hintTextColor),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                child: Text("No items in this list.",
                    style: TextStyle(
                        fontFamily: 'Sen',
                        fontSize: 18,
                        color: hintTextColor)))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['isChecked'],
                    onChanged: (value) => _toggleItem(index),
                    activeColor: Color(0xFF6E86D0),
                    checkColor: Colors.green,
                  ),
                  title: Text(
                    item['name'],
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 18,
                      color: textColor,
                      decoration: item['isChecked']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteItem(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(
                      hintText: "Add an item...",
                      hintStyle: TextStyle(
                          fontFamily: 'PlayfairDisplay', color: hintTextColor),
                      filled: true,
                      fillColor:
                      isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: textColor),
                    onSubmitted: (value) => _addItem(),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _addItem,
                  backgroundColor: Color(0xFF6E86D0),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

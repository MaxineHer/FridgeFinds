import 'package:flutter/material.dart';

class ListDetailScreen extends StatefulWidget {
  final String listName;
  final DateTime createdAt;

  const ListDetailScreen({Key? key, required this.listName, required this.createdAt}) : super(key: key);

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  List<Map<String, dynamic>> items = []; // Stores items locally
  TextEditingController itemController = TextEditingController();

  void _addItem() {
    if (itemController.text.isNotEmpty) {
      setState(() {
        items.add({'name': itemController.text, 'isChecked': false});
        itemController.clear();
      });
    }
  }

  void _toggleItem(int index) {
    setState(() {
      items[index]['isChecked'] = !items[index]['isChecked'];
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detects light or dark mode
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
          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Created on: ${widget.createdAt.day}/${widget.createdAt.month}/${widget.createdAt.year}",
              style: TextStyle(fontSize: 14, color: hintTextColor),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text("No items in this list.", style: TextStyle(fontSize: 18, color: hintTextColor)))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['isChecked'],
                    onChanged: (value) => _toggleItem(index),
                    activeColor: Color(0xFF6E86D0),
                    checkColor: Colors.white,
                  ),
                  title: Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor,
                      decoration: item['isChecked'] ? TextDecoration.lineThrough : TextDecoration.none,
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
                      hintStyle: TextStyle(color: hintTextColor),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: textColor),
                    onSubmitted: (value) => _addItem(), // Handles Enter key press
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

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  double _storageUsed = 0.0; // Storage used by the app
  bool _isOffline = false; // To track offline mode status
  double _networkUsage = 0.0; // Simulated network usage (in MB)

  @override
  void initState() {
    super.initState();
    _getStorageUsage();
  }

  // Function to calculate storage used by the app
  Future<void> _getStorageUsage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final totalSpace = await directory.stat();
      setState(() {
        _storageUsed = totalSpace.size / (1024 * 1024); // Convert bytes to MB
      });
    } catch (e) {
      // Handle error
      print("Error getting storage: $e");
    }
  }

  // Simulate network usage update
  void _updateNetworkUsage() {
    setState(() {
      _networkUsage += 1.0; // Increase network usage by 1MB for each update
    });
  }

  // Toggle offline mode
  void _toggleOfflineMode(bool value) {
    setState(() {
      _isOffline = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Storage and Data",
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Storage Used
            ListTile(
              leading: const Icon(Icons.storage),
              title: Text(
                "Storage Used",
                style: TextStyle(fontFamily: 'Sen', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${_storageUsed.toStringAsFixed(2)} MB", style: TextStyle(fontFamily: 'Sen')),
            ),
            const SizedBox(height: 16),
            // Offline Mode Toggle
            ListTile(
              leading: const Icon(Icons.offline_bolt),
              title: Text(
                "Offline Mode",
                style: TextStyle(fontFamily: 'Sen', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_isOffline ? "Enabled" : "Disabled", style: TextStyle(fontFamily: 'Sen')),
              trailing: Switch(
                value: _isOffline,
                onChanged: _toggleOfflineMode,
              ),
            ),
            const SizedBox(height: 16),
            // Network Usage (Simulated)
            ListTile(
              leading: const Icon(Icons.network_check),
              title: Text(
                "Network Usage",
                style: TextStyle(fontFamily: 'Sen', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              //subtitle: Text("${_networkUsage.toStringAsFixed(2)} MB", style: TextStyle(fontFamily: 'Sen')),
              subtitle: Text("345.76 MB", style: TextStyle(fontFamily: "Sen")),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

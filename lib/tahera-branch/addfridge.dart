import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import
import 'qrscanner.dart'; // Your QRScannerScreen remains unchanged
import 'fridge_details_screen.dart'; // (Optional – if you navigate there later)
import 'fridge_model.dart'; // Ensure this model includes a toMap() method

class AddFridgeQRScreen extends StatefulWidget {
  const AddFridgeQRScreen({super.key});

  @override
  State<AddFridgeQRScreen> createState() => _AddFridgeQRScreenState();
}

class _AddFridgeQRScreenState extends State<AddFridgeQRScreen> {
  // Popup to show after fridge is added
  void _showFridgeAddedPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF6E86D0),
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Fridge Added',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Called when "SCAN" is pressed
  Future<void> _onScanPressed() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
    if (!mounted || result == null) return;
    // Parse the scanned JSON data and store it in Firestore
    try {
      final data = jsonDecode(result);
      final fridge = Fridge(
        modelNumber: data["modelNumber"] ?? "Unknown Model",
        serialNumber: data["serialNumber"] ?? "N/A",
        dateOfConnection: data["dateOfConnection"] ?? "N/A",
        connectionStatus: data["connectionStatus"] ?? "Unknown",
        iotStatus: data["iotStatus"] ?? "N/A",
        linkedAccounts: data["linkedAccounts"] ?? "N/A",
      );
      await FirebaseFirestore.instance.collection('fridges').add(fridge.toMap());
      _showFridgeAddedPopup();
    } catch (e) {
      debugPrint("Error parsing scanned data: $e");
    }
  }

  /// Called when "Fake JSON" is pressed for testing purposes
  void _onFakeJsonPressed() {
    const fakeJson = '''
    {
      "modelNumber": "LG Smart ThinQ Refrigerator RS267LABP",
      "serialNumber": "123456789987654321",
      "dateOfConnection": "2024-02-24 2:30 PM",
      "isConnected": true,
      "connectionStatus": "Connected",
      "iotStatus": "Active",
      "linkedAccounts": "Accounts that have access to the same fridge.",
      "pairingOptions": "Reconnect or reset the connection.",
      "lastSyncTime": "2 minutes ago"
    }
    ''';

    try {
      final data = jsonDecode(fakeJson);
      final fridge = Fridge(
        modelNumber: data["modelNumber"] ?? "Unknown Model",
        serialNumber: data["serialNumber"] ?? "N/A",
        dateOfConnection: data["dateOfConnection"] ?? "N/A",
        connectionStatus: data["connectionStatus"] ?? "Unknown",
        iotStatus: data["iotStatus"] ?? "N/A",
        linkedAccounts: data["linkedAccounts"] ?? "N/A",
      );
      FirebaseFirestore.instance.collection('fridges').add(fridge.toMap());
      _showFridgeAddedPopup();
    } catch (e) {
      debugPrint("Error parsing fake JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Fridge',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Align the QR code within frame to scan',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // SCAN button remains unchanged
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onScanPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E86D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SCAN',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Fake JSON button remains unchanged
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onFakeJsonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Fake JSON',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

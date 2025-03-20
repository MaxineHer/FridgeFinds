import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qrscanner.dart';
import 'fridge_model.dart';

class AddFridgeQRScreen extends StatefulWidget {
  const AddFridgeQRScreen({super.key});

  @override
  State<AddFridgeQRScreen> createState() => _AddFridgeQRScreenState();
}

class _AddFridgeQRScreenState extends State<AddFridgeQRScreen> {
  /// Scan QR Code and store in Firebase
  Future<void> _onScanPressed() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (!mounted || result == null) return;

    try {
      final data = jsonDecode(result);
      final fridge = Fridge(
        modelNumber: data["modelNumber"] ?? "Unknown Model",
        serialNumber: data["serialNumber"] ?? "N/A",
        dateOfConnection: data["dateOfConnection"] ?? "N/A",
        connectionStatus: "Connected", // Hardcoded
        iotStatus: "Active", // Hardcoded
      );

      await FirebaseFirestore.instance.collection('fridges').add(fridge.toMap());
      _showFridgeAddedPopup();
    } catch (e) {
      debugPrint("Error parsing scanned data: $e");
    }
  }

  /// Show success popup when fridge is added
  void _showFridgeAddedPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF6E86D0), size: 48),
                SizedBox(height: 16),
                Text(
                  'Fridge Added Successfully!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensures a clean background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Fridge',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Placeholder scanner area
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),

            // Instruction text
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

            // SCAN button
            SizedBox(
              width: double.infinity,
              height: 50,
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
          ],
        ),
      ),
    );
  }
}
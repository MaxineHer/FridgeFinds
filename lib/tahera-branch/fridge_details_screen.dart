import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_model.dart';
import 'fridgecon1.dart';

class FridgeDetailsScreen extends StatelessWidget {
  final String fridgeDocId;
  const FridgeDetailsScreen({Key? key, required this.fridgeDocId}) : super(key: key);

  /// Delete fridge from Firebase
  void _removeFridge(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Fridge'),
          content: const Text('Are you sure you want to delete this fridge from your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('fridges').doc(fridgeDocId).delete();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FridgeConnectivityScreen()),
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('fridges').doc(fridgeDocId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: const Text('Fridge Details')),
            body: const Center(child: Text('Fridge not found')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final fridge = Fridge.fromMap(data);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Fridge Details',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 26,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Section
                const Text(
                  'Basic Information',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoBox('Model Number', fridge.modelNumber),
                _buildInfoBox('Serial Number', fridge.serialNumber),
                _buildInfoBox('Date of Connection', fridge.dateOfConnection),
                _buildInfoBox('Connection Status', "Connected"),

                const SizedBox(height: 24),

                // Custom Features Section
                const Text(
                  'Custom Features',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoBox('Camera/IoT Status', "Active"),

                const SizedBox(height: 30),

                // Remove Fridge Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _removeFridge(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Remove Fridge',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates a styled box for displaying information
  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE3F0), // Light blue background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
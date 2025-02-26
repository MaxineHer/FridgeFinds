import 'package:flutter/material.dart';
import 'fridge_model.dart';

class FridgeDetailsScreen extends StatelessWidget {
  final Fridge fridge;
  const FridgeDetailsScreen({Key? key, required this.fridge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Fridge Details',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            _buildInfoBox('Connection Status', fridge.connectionStatus),

            const SizedBox(height: 24),

            const Text(
              'Custom Features',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildInfoBox('Camera/IoT Status', fridge.iotStatus),
            _buildInfoBox('Linked Accounts', fridge.linkedAccounts),
            _buildInfoBox('Pairing Options', fridge.pairingOptions),
            _buildInfoBox('Last Sync Time', fridge.lastSyncTime),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE3F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

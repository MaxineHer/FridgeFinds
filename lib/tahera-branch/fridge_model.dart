class Fridge {
  final String modelNumber;
  final String serialNumber;
  final String dateOfConnection;
  final String connectionStatus;
  final String iotStatus;

  Fridge({
    required this.modelNumber,
    required this.serialNumber,
    required this.dateOfConnection,
    required this.connectionStatus,
    required this.iotStatus,
  });

  // Convert a Fridge instance to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'modelNumber': modelNumber,
      'serialNumber': serialNumber,
      'dateOfConnection': dateOfConnection,
      'connectionStatus': "Connected",
      'iotStatus': "Active",
    };
  }

  // Create a Fridge instance from a Firestore document
  factory Fridge.fromMap(Map<String, dynamic> map) {
    return Fridge(
      modelNumber: map['modelNumber'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      dateOfConnection: map['dateOfConnection'] ?? '',
      connectionStatus: "Connected",
      iotStatus: "Active",
    );
  }
}
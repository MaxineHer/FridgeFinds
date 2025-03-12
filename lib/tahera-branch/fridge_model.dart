class Fridge {
  final String modelNumber;
  final String serialNumber;
  final String dateOfConnection;
  final String connectionStatus;
  final String iotStatus;
  final String linkedAccounts;

  Fridge({
    required this.modelNumber,
    required this.serialNumber,
    required this.dateOfConnection,
    required this.connectionStatus,
    required this.iotStatus,
    required this.linkedAccounts,
  });

  // Convert a Fridge instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'modelNumber': modelNumber,
      'serialNumber': serialNumber,
      'dateOfConnection': dateOfConnection,
      'connectionStatus': connectionStatus,
      'iotStatus': iotStatus,
      'linkedAccounts': linkedAccounts,
    };
  }

  // Create a Fridge instance from a Map
  factory Fridge.fromMap(Map<String, dynamic> map) {
    return Fridge(
      modelNumber: map['modelNumber'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      dateOfConnection: map['dateOfConnection'] ?? '',
      connectionStatus: map['connectionStatus'] ?? '',
      iotStatus: map['iotStatus'] ?? '',
      linkedAccounts: map['linkedAccounts'] ?? '',
    );
  }
}

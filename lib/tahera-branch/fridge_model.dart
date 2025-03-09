class Fridge {
  final String modelNumber;
  final String serialNumber;
  final String dateOfConnection;
  final bool isConnected;
  final String connectionStatus;
  final String iotStatus;
  final String linkedAccounts;
  final String pairingOptions;
  final String lastSyncTime;

  Fridge({
    required this.modelNumber,
    required this.serialNumber,
    required this.dateOfConnection,
    required this.isConnected,
    required this.connectionStatus,
    required this.iotStatus,
    required this.linkedAccounts,
    required this.pairingOptions,
    required this.lastSyncTime,
  });

  // Convert a Fridge instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'modelNumber': modelNumber,
      'serialNumber': serialNumber,
      'dateOfConnection': dateOfConnection,
      'isConnected': isConnected,
      'connectionStatus': connectionStatus,
      'iotStatus': iotStatus,
      'linkedAccounts': linkedAccounts,
      'pairingOptions': pairingOptions,
      'lastSyncTime': lastSyncTime,
    };
  }

  // Create a Fridge instance from a Map
  factory Fridge.fromMap(Map<String, dynamic> map) {
    return Fridge(
      modelNumber: map['modelNumber'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      dateOfConnection: map['dateOfConnection'] ?? '',
      isConnected: map['isConnected'] ?? false,
      connectionStatus: map['connectionStatus'] ?? '',
      iotStatus: map['iotStatus'] ?? '',
      linkedAccounts: map['linkedAccounts'] ?? '',
      pairingOptions: map['pairingOptions'] ?? '',
      lastSyncTime: map['lastSyncTime'] ?? '',
    );
  }
}

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
}

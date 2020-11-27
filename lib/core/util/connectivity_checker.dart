import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart'; //For StreamController/Stream


class ConnectivityChecker {
  static final ConnectivityChecker _singleton = new ConnectivityChecker._internal();
  ConnectivityChecker._internal();

  static ConnectivityChecker getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = new StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _dataConnectionChecker.onStatusChange.listen(_internetStatusChange);
    checkConnection();
  }


  Stream get connectionChange => connectionChangeController.stream;


  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  void _internetStatusChange(status) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    DataConnectionChecker dataConnectionChecker = configureDataConnectionChecker();
    hasConnection = await dataConnectionChecker.hasConnection;

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  DataConnectionChecker configureDataConnectionChecker() {
    
    var dataConnectionChecker = DataConnectionChecker();
    
    List<AddressCheckOptions> addresses = DataConnectionChecker
        .DEFAULT_ADDRESSES.map((addressCheckOptions) =>
        AddressCheckOptions(
            addressCheckOptions.address,
            port: addressCheckOptions.port,
            timeout: Duration(seconds: 3)
        )
    ).toList();
    
    
    dataConnectionChecker.addresses = addresses;
    return dataConnectionChecker;
  }
}
import 'dart:async';
import 'dart:io'; //InternetAddress utility

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart'; //For StreamController/Stream


class ConnectivityChecker {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectivityChecker _singleton = new ConnectivityChecker._internal();
  ConnectivityChecker._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectivityChecker getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = new StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //data_connection_checker
  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _dataConnectionChecker.onStatusChange.listen(_internetStatusChange);
    checkConnection();
  }


  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //data_connection_checker
  void _internetStatusChange(status) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    hasConnection = await DataConnectionChecker().hasConnection;

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
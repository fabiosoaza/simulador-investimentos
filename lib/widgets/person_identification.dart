import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/util/connectivity_checker.dart';

class PersonIdentification extends StatefulWidget {
  @override
  _PersonIdentificationState createState() => _PersonIdentificationState();
}

class _PersonIdentificationState extends State<PersonIdentification> {

  StreamSubscription _connectionChangeStreamSubscription;

  ConnectivityChecker _connectivityChecker;


  bool _isOnline = false;



  @override
  void initState() {
    super.initState();
    _connectivityChecker = ApplicationContext.instance().connectivityChecker;
    _connectionChangeStreamSubscription = _connectivityChecker.connectionChange.listen(_connectionChanged);
    _isOnline = _connectivityChecker.hasConnection;

  }

  void _connectionChanged(dynamic hasConnection) {
    if(this.mounted) {
      setState(() {
        _isOnline = hasConnection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.only(top:10),
        child: Row(
          //horizontal
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Image.asset("assets/coin.png",
              width: 40,
              color: Colors.white,
            )
            ,
            SizedBox(width: 10,),
            Text("Simulador de Carteira(${_isOnline?  'Online' :  'Offline'})",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
            )
          ],
        ),

      )

      ;
  }
}

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class PersonIdentification extends StatelessWidget {
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
              width: 50,
              color: Colors.white,
            )
            ,
            SizedBox(width: 10,),
            Text("Simulador de Carteira",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
            )
          ],
        ),

      )

      ;
  }
}

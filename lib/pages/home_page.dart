import "package:flutter/material.dart";
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/card_ativos_carteira.dart';
import 'package:simulador_investimentos/widgets/card_rentabilidade.dart';
import 'package:simulador_investimentos/widgets/person_identification.dart';
import 'package:simulador_investimentos/widgets/tab_option.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: PersonIdentification(),
         elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                  children: [
                    CardRentabilidade(),
                  ],
                )
            ),
            SizedBox(height: 20,)
            ,
            TabOption()
          ],
        ),
      ),
    );
  }
}

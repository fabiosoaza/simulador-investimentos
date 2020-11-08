import "package:flutter/material.dart";
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/card_ativos_carteira.dart';
import 'package:simulador_investimentos/widgets/person_identification.dart';
import 'package:simulador_investimentos/widgets/tab_option.dart';

class AtivosCarteiraPage extends StatefulWidget {


  @override
  _AtivosCarteiraPageState createState() => _AtivosCarteiraPageState();
}

class _AtivosCarteiraPageState extends State<AtivosCarteiraPage> {


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
                    CardAtivosCarteira(),
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

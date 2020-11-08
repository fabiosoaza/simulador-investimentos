import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/card_ativos.dart';
import 'package:simulador_investimentos/widgets/person_identification.dart';
import 'package:simulador_investimentos/widgets/tab_option.dart';

class MercadoPage extends StatefulWidget {
  @override
  _MercadoPageState createState() => _MercadoPageState();
}

class _MercadoPageState extends State<MercadoPage> {


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
                    CardAtivos(TipoAtivo.ACAO, "Ações"),
                    SizedBox(height: 15,),
                    CardAtivos(TipoAtivo.CRYPTOMOEDA, "Criptomoedas"),
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

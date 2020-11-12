import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulador_investimentos/widgets/util/navigation_utils.dart';

class TabOption extends StatefulWidget {
  @override
  _TabOptionState createState() => _TabOptionState();
}

class _TabOptionState extends State<TabOption> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 100,
        child:  ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return Row(
                children: [
                  menuRentabilidade(),
                  SizedBox(width: 5,),
                  menuCarteira(),
                  SizedBox(width: 5,),
                  menuMercado(),
                ],
              );
            }),
      );
  }

  Widget menuRentabilidade() {
    return menu('Patrimônio', Icons.show_chart, () {
      NavigationUtils.replaceWithHome(context);
    });
  }

  Widget menuCarteira() {
    return menu('Carteira', Icons.account_balance_wallet, () {
      NavigationUtils.replaceWithAtivosCarteira(context);
    });
  }

  Widget menuMercado() {
    return menu('Mercado', Icons.assessment, () {
      NavigationUtils.replaceWithMercado(context);
    });
  }

  Widget menu(String title,  IconData icon, Function() onTapAction) {
    var onTap2 = (){
            NavigationUtils.replaceWithHome(context);
          };
    var icon = Icons.show_chart;
    var title = 'Patrimônio';
    return
      InkWell(
          onTap: onTap2,
          child:
          Container(
            height: 100,
            width: 100,
            color: Color.fromRGBO(255, 255, 255, .2),
            padding: EdgeInsets.all(10),
            child: Column(
              //vertical
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, color: Colors.white, size: 30),
                Spacer(),
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          ));
  }









}

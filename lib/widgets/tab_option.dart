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
    return
      InkWell(
        onTap: (){
          NavigationUtils.replaceWithHome(context);
        },
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
                      Icon(Icons.show_chart, color: Colors.white, size: 30),
                      Spacer(),
                      Text('Patrimônio',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ],
                  ),
                ));
  }

  Widget menuCarteira() {
    return
      InkWell(
          onTap: (){
            NavigationUtils.replaceWithAtivosCarteira(context);
          },
          child: Container(
            height: 100,
            width: 100,
            color: Color.fromRGBO(255, 255, 255, .2),
            padding: EdgeInsets.all(10),
            child: Column(
              //vertical
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
                Spacer(),
                Text('Carteira',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          )
      );
  }


  Widget menuMercado() {
    return
      InkWell(
          onTap: (){
            NavigationUtils.replaceWithMercado(context);
          },
      child: Container(
      height: 100,
      width: 100,
      color: Color.fromRGBO(255, 255, 255, .2),
      padding: EdgeInsets.all(10),
      child: Column(
        //vertical
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.assessment, color: Colors.white, size: 30),
          Spacer(),
          Text('Mercado',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))
        ],
      ),
    )
      );
  }



}

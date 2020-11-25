import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/pages/ativos_carteira_page.dart';
import 'package:simulador_investimentos/pages/home_page.dart';
import 'package:simulador_investimentos/pages/mercado_page.dart';
import 'package:simulador_investimentos/pages/operacao_page.dart';
import 'package:simulador_investimentos/themes/colors.dart';

class NavigationUtils {
  static void navigateToMercado(BuildContext context) async {
    navigateTo(context, MercadoPage());
   }

  static void navigateToHome(BuildContext context) async {
    navigateTo(context, HomePage());
  }

  static void navigateToOperacao( BuildContext context, TipoOperacao tipoOperacao, Ativo ativo) async {
    navigateTo(context, OperacaoPage(tipoOperacao, ativo));
  }

  static void navigateToAtivosCarteira( BuildContext context) async {
    navigateTo(context, AtivosCarteiraPage());
  }

  static Future<dynamic> navigateTo( BuildContext context, Widget widget){
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  static void goBack( BuildContext context){
    return  Navigator.pop(context);
  }

  static void close( BuildContext context){
    return  goBack(context);
  }

  static  Future<dynamic>  replaceWithMercado(BuildContext context) async {
    return replacePageWith(context, MercadoPage());
  }

  static  Future<dynamic>  replaceWithHome(BuildContext context) async {
    return replacePageWith(context, HomePage());
  }

  static  Future<dynamic>  replaceWithAtivosCarteira(BuildContext context) async {
    return replacePageWith(context, AtivosCarteiraPage());
  }

  static  Future<dynamic>  replaceWithOperacao( BuildContext context, TipoOperacao tipoOperacao, Ativo ativo) async {
    return replacePageWith(context, OperacaoPage(tipoOperacao, ativo));
  }


  static void showMessage(final BuildContext context, String text, {Function onVisible} ) {
    FocusScope.of(context).unfocus();
    showFlushbar(text, context);
  }

  static void showSnackBar(BuildContext context, Function onVisible, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        onVisible: onVisible??(){},
        backgroundColor: kWhiteColor,
        content: Text(
          text,
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        action: SnackBarAction(
    
            label: 'Fechar', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  static void showFlushbar(String text, BuildContext context) {
    Flushbar(
      backgroundColor: kWhiteColor,
      isDismissible: true,
      messageText: Text(
        text,
        style: TextStyle(
            color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      duration:  Duration(seconds: 3),
    )..show(context);
  }

  static void showTopNotification(String text, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        backgroundColor: kWhiteColor,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        messageText: Text(
          text,
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        duration:  Duration(seconds: 3),
      )..show(context);
    });



  }

  static void closePage(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  static Future<dynamic> replacePageWith(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }


  static void showMenuOperacaoAtivo(BuildContext context, Ativo ativo){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: Wrap(children: <Widget>[
                _menuComprarAtivo(context, ativo),
                _menuVenderAtivo(context, ativo)

              ]
              )
          );
        });
  }

  static Widget _menuComprarAtivo(BuildContext context, Ativo ativo) {
    var operacao = TipoOperacao.COMPRA;
    var icon = Icons.add_shopping_cart;
    var text = 'Comprar ${ativo.ticker}';
    return _menuItem(context, operacao, ativo, icon, text);
  }

  static Widget _menuVenderAtivo(BuildContext context, Ativo ativo) {
    var operacao = TipoOperacao.VENDA;
    var icon = Icons.remove_shopping_cart;
    var text = 'Vender ${ativo.ticker}';
    return _menuItem(context, operacao, ativo, icon, text);
  }


  static ListTile _menuItem(BuildContext context, TipoOperacao operacao, Ativo ativo, IconData icon, String text) {
    return ListTile(
        onTap: () {
          NavigationUtils.close(context);
          NavigationUtils.navigateToOperacao(
              context, operacao, ativo);
        },
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: kNighSky))
    );
  }

}

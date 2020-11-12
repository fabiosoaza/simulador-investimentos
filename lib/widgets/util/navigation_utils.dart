import 'package:flutter/material.dart';
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

  static Future<dynamic> navigateTo( BuildContext context, Widget widget){
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
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
  
  
  
  static void showToast(BuildContext context, String text, {Function onVisible} ) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
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
}

import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';

class AtivoUtils{

  static int getNumeroCasasDecimais(Ativo ativo ){
    return ativo.tipo == TipoAtivo.ACAO ? 2 : 4;
  }


}
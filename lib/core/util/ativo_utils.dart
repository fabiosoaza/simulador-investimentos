import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_constants.dart';

class AtivoUtils{

  static int getNumeroCasasDecimais(Ativo ativo ){
    return ativo.tipo == AtivoConstants.TIPO_ACAO ? 2 : 4;
  }


}
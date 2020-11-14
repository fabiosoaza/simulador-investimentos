import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';

class ValidadorVendaAtivoCarteira {
  String _valor;
  AtivoCarteira _ativoCarteira;

  ValidadorVendaAtivoCarteira(String valor, AtivoCarteira ativoCarteira) {
    this._valor = valor;
    this._ativoCarteira = ativoCarteira;
  }

  bool validar() {
    var quantidadeParaVenda =
        double.tryParse(_valor) == null ? 0 : double.tryParse(_valor);
    var quantidadeNaCarteira =
        _ativoCarteira == null ? 0 : _ativoCarteira.quantidade;
    return quantidadeNaCarteira >= quantidadeParaVenda;
  }
}

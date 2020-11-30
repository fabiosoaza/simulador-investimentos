import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';

class Carteira {
  List<AtivoCarteiraCotacao> _ativosCarteiraCotacao;

  Carteira(List<AtivoCarteiraCotacao> ativosCarteiraCotacao) {
    this._ativosCarteiraCotacao = ativosCarteiraCotacao;
  }

  Carteira.nova() {
    this._ativosCarteiraCotacao =  List<AtivoCarteiraCotacao>();
  }

  List<AtivoCarteiraCotacao> get ativosCarteiraCotacao => _ativosCarteiraCotacao;

  ValorMonetario calcularValorAtualCarteira() {
    var valorTotalCarteira = ValorMonetario.brl("0");
    _ativosCarteiraCotacao.forEach((ativoCarteiraCotacao) {
      var valorTotal = ativoCarteiraCotacao.calcularValorAtual();
      valorTotalCarteira = valorTotalCarteira.somar(valorTotal);
    });
    return valorTotalCarteira;
  }

  ValorMonetario calcularValorCompraCarteira() {
    var valorTotalCompraCarteira = ValorMonetario.brl("0");
    _ativosCarteiraCotacao.forEach((ativoCarteiraCotacao) {
      var valorTotalCompra = ativoCarteiraCotacao.ativoCarteira.calcularValorTotal();
      valorTotalCompraCarteira = valorTotalCompraCarteira.somar(valorTotalCompra);
    });
    return valorTotalCompraCarteira;
  }

  ValorMonetario calcularLucro(){
      return calcularValorAtualCarteira().subtrair( calcularValorCompraCarteira());
  }

  double calcularRentabilidadePercentual(){
    var valorCompra = calcularValorCompraCarteira().valorAsDouble();
    var rentabilidade = valorCompra == 0 ? 0.toDouble() : calcularLucro().multiplicar(100.toDouble()).dividir(valorCompra).valorAsDouble();
    return rentabilidade;
  }

  AtivoCarteira findAtivoCarteira(Ativo ativo){
     return findAtivoCarteiraByTicker(ativo.ticker);
  }

  AtivoCarteira findAtivoCarteiraByTicker(String ticker){
    var ativoCarteira;
    _ativosCarteiraCotacao.forEach((ativoCarteiraCotacao) {
      if(ativoCarteiraCotacao.ativoCarteira.ativo.ticker == ticker){
        ativoCarteira = ativoCarteiraCotacao.ativoCarteira;
      }
    });
    return ativoCarteira;
  }


}

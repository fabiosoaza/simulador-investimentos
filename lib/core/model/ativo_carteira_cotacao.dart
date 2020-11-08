import 'package:simulador_investimentos/core/model/cotacao.dart';
import 'package:simulador_investimentos/core/model/valor_monetario.dart';

import 'ativo_carteira.dart';

class AtivoCarteiraCotacao {
  AtivoCarteira _ativoCarteira;
  Cotacao _cotacao;

  AtivoCarteiraCotacao(AtivoCarteira ativoCarteira, Cotacao cotacao) {
    this._ativoCarteira = ativoCarteira;
    this._cotacao = cotacao;
  }

  AtivoCarteira get ativoCarteira => _ativoCarteira;

  Cotacao get cotacao => _cotacao;
  
  double rentabilidadePercentual(){
    var diferenca = rentabilidade();
    return diferenca.multiplicar(100).dividir(ativoCarteira.precoMedio.valorAsDouble()).valorAsDouble();

  }

  ValorMonetario calcularValorAtual(){
    return _cotacao.valor.multiplicar(_ativoCarteira.quantidade);
  }


  ValorMonetario rentabilidade() => cotacao.valor.subtrair(_ativoCarteira.precoMedio);
}

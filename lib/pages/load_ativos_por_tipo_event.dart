import 'package:simulador_investimentos/pages/bloc_events.dart';

class LoadAtivosPorTipoEvent extends LoadDataEvent{

  String _tipoAtivo;

  LoadAtivosPorTipoEvent(String tipoAtivo):super(){
    this._tipoAtivo = tipoAtivo;
  }

  String get tipoAtivo=> _tipoAtivo;

}
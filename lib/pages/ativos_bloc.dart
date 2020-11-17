import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_repository.dart';
import 'package:simulador_investimentos/pages/base_loadable_bloc.dart';
import 'package:simulador_investimentos/pages/bloc_events.dart';
import 'package:simulador_investimentos/pages/load_ativos_por_tipo_event.dart';

class AtivosBloc extends BaseLoadableBloc<List<Ativo>> {

  AtivoRepository _ativoRepository;

  AtivosBloc(AtivoRepository ativoRepository) : super() {
    this._ativoRepository = ativoRepository;
  }

  @override
  Future<List<Ativo>> loadData(LoadDataEvent event) async{
    return _ativoRepository.listarPorTipo((event as LoadAtivosPorTipoEvent).tipoAtivo);
  }
}

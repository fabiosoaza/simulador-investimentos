import 'dart:async';

import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';

import 'base_loadable_bloc.dart';
import 'bloc_events.dart';

class AtivosCarteiraBloc extends BaseLoadableBloc<Carteira> {

  CarteiraRepository _carteiraRepository;

  AtivosCarteiraBloc(CarteiraRepository carteiraRepository): super() {
    this._carteiraRepository = carteiraRepository;
  }

  @override
  Future<Carteira> loadData(LoadDataEvent event) async {
    return _carteiraRepository.carregar();
  }
}
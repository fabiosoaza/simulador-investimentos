import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simulador_investimentos/pages/base/bloc_events.dart';

import 'base_bloc.dart';

abstract class BaseLoadableBloc<T> extends BaseBloc{

  final _loadDataController = BehaviorSubject<T>();
  Function(T) get _onDataChanged => _loadDataController.sink.add;
  Stream<T> get outData => _loadDataController.stream;
  
  BaseLoadableBloc():super();

  @override
  void handleEvents(BlocEvents event) {
    if (event is LoadDataEvent) {
      _handleLoadData(event);
    }
  }

  void _handleLoadData(LoadDataEvent event)  {
    final withLoading = _loadDataController.value == null;

    doOnlineAction(
        withLoading: withLoading,
        action: () async {
          var data = await loadData(event);
          _onDataChanged(data);
        });
  }

  Future<T> loadData(LoadDataEvent event);

  @override
  void dispose() {
    super.dispose();
    _loadDataController.drain<dynamic>();
    _loadDataController.close();
  }


}
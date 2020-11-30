import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_events.dart';

abstract class BaseBloc{

  StreamSubscription _subscriptionEvent;
  final _eventsController = BehaviorSubject<BlocEvents>();
  Function(BlocEvents) get onEventChanged => _eventsController.sink.add;
  Stream<BlocEvents> get _events => _eventsController.stream;


  Future<void> doOnlineAction({
    bool withLoading = true,
    Function action
  }) async {
    try {
      if (withLoading) {
        _onLoadingChange(true);
      }
      await action?.call();
    } on Exception catch(error, _) {
      log(error.toString());
    } finally {
      if (withLoading) {
        _onLoadingChange(false);
      }
    }
  }

   BaseBloc(){
    _subscriptionEvent = _events.listen(handleEvents);
  }

  void handleEvents(BlocEvents event);

  final _loadingController = BehaviorSubject<bool>.seeded(false);
  Function(bool) get _onLoadingChange => _loadingController.sink.add;
  Stream<bool> get isLoading => _loadingController.stream;

  @mustCallSuper
  void dispose() {
    _subscriptionEvent?.cancel();
    _eventsController.drain<dynamic>();
    _eventsController.close();
    _loadingController.drain<dynamic>();
    _loadingController.close();
  }

}
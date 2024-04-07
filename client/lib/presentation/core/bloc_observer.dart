import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mars_flutter/common/log.dart';


class AppBlocObserver extends BlocObserver {

  @override

  void onTransition(Bloc bloc, Transition transition) {

    super.onTransition(bloc, transition);

    logger.d('${bloc.runtimeType} $transition');

  }


  @override

  void onChange(BlocBase bloc, Change change) {

    super.onChange(bloc, change);

    logger.d('${bloc.runtimeType}');

  }


  @override

  void onEvent(Bloc bloc, Object? event) {

    super.onEvent(bloc, event);

    logger.d('${bloc.runtimeType} $event');

  }


  @override

  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {

    logger.d('${bloc.runtimeType} $error $stackTrace');

    super.onError(bloc, error, stackTrace);

  }

}


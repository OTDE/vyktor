import 'package:bloc/bloc.dart';

/// As basic as a [BlocDelegate] can get.
///
/// Used for debugging so I don't lose my mind debugging where the BloC is at.
class BasicBlocDelegate extends BlocDelegate {
  /// Fires an event's [toString] method when an [event] is
  /// dispatched to the [bloc].
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType.toString()}: $event');
  }

  /// Sends information about [bloc] state [transition]s.
  ///
  /// Includes event that caused the change, the previous state, and the next state.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType.toString()}: $transition');
  }

  /// Prints the [stacktrace] if a [bloc] throws an [error].
  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('${bloc.runtimeType.toString()}: $error');
  }
}

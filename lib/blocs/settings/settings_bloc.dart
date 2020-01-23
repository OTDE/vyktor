import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../models/models.dart';

import 'settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  @override
  SettingsState get initialState => InitializingSettings();


  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitializeSettings) {
      yield* _mapInitializeSettingsToState(event);
    }
    if (state is SettingsLoaded) {
      if (event is SetRadius) {
        yield* _mapSetRadiusToState(state, event);
      } else if (event is SetAfterDate) {
        yield* _mapSetAfterDateToState(state, event);
      } else if (event is SetBeforeDate) {
        yield* _mapSetBeforeDateToState(state, event);
      } else if (event is SetExploreModeEnabled) {
        yield* _mapSetExploreModeToState(state, event);
      }
    }
  }

  Stream<SettingsState> _mapInitializeSettingsToState(InitializeSettings event) async* {
    await SettingsClient().init();
    yield SettingsLoaded(
      radius: await SettingsClient().radius,
      afterDate: toDateTime(await SettingsClient().afterDate),
      beforeDate: toDateTime(await SettingsClient().beforeDate),
      exploreModeEnabled: await SettingsClient().exploreModeEnabled,
    );
  }

  Stream<SettingsState> _mapSetRadiusToState(SettingsLoaded state, SetRadius event) async* {
    await SettingsClient().setRadius(event.radius);
    yield SettingsLoaded(
      radius: event.radius,
      afterDate: state.afterDate,
      beforeDate: state.beforeDate,
      exploreModeEnabled: state.exploreModeEnabled,
    );
  }

  Stream<SettingsState> _mapSetAfterDateToState(SettingsLoaded state, SetAfterDate event) async* {
    await SettingsClient().setAfterDate(toUnixTimeStamp(event.date));
    yield SettingsLoaded(
      radius: state.radius,
      afterDate: event.date,
      beforeDate: state.beforeDate,
      exploreModeEnabled: state.exploreModeEnabled,
    );
  }

  Stream<SettingsState> _mapSetBeforeDateToState(SettingsLoaded state, SetBeforeDate event) async* {
    await SettingsClient().setBeforeDate(toUnixTimeStamp(event.date));
    yield SettingsLoaded(
      radius: state.radius,
      afterDate: state.afterDate,
      beforeDate: event.date,
      exploreModeEnabled: state.exploreModeEnabled,
    );
  }

  Stream<SettingsState> _mapSetExploreModeToState(SettingsLoaded state, SetExploreModeEnabled event) async* {
    await SettingsClient().setExploreModeEnabled(event.exploreModeEnabled);
    yield SettingsLoaded(
      radius: state.radius,
      afterDate: state.afterDate,
      beforeDate: state.beforeDate,
      exploreModeEnabled: event.exploreModeEnabled,
    );
  }

  DateTime toDateTime(int unixTimeStamp) => DateTime.fromMillisecondsSinceEpoch(unixTimeStamp * 1000);
  int toUnixTimeStamp(DateTime date) => (date.millisecondsSinceEpoch / 1000).floor();

}
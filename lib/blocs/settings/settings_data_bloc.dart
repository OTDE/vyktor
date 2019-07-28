import 'dart:async';
import 'package:bloc/bloc.dart';
import './settings_data_barrel.dart';

class SettingsDataBloc extends Bloc<SettingsDataEvent, SettingsDataState> {
  @override
  SettingsDataState get initialState => InitialSettingsDataState();

  @override
  Stream<SettingsDataState> mapEventToState(
    SettingsDataEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

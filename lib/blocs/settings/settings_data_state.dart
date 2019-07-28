import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsDataState extends Equatable {
  SettingsDataState([List props = const []]) : super(props);
}

class InitialSettingsDataState extends SettingsDataState {}

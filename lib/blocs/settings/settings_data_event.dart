import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsDataEvent extends Equatable {
  SettingsDataEvent([List props = const []]) : super(props);
}

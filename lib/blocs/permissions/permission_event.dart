import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class RequestLocationPermissions extends PermissionEvent {
  @override
  String toString() => 'Requesting location permissions';
}
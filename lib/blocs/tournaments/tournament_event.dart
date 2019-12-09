import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class SelectTournament extends TournamentEvent {
  final int id;

  const SelectTournament(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Selecting tournament with id $id.';
}

class DeselectTournament extends TournamentEvent {
  @override
  String toString() => 'Deselecting tournament.';
}
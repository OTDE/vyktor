import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
abstract class TournamentState extends Equatable {
  const TournamentState();

  @override
  List<Object> get props => [];
}

class TournamentLoading extends TournamentState {
  @override
  String toString() => 'Tournament data loading';
}

class TournamentSelected extends TournamentState {
  final Tournament tournament;

  const TournamentSelected(this.tournament);

  @override
  List<Object> get props => [tournament];

  @override
  String toString() => 'Tournament with id ${tournament.id} and name ${tournament.name} selected.';
}

class TournamentNotSelected extends TournamentState {
  @override
  String toString() => 'Tournament not selected';
}
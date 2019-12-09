import 'tournament.dart';

class TournamentModel {

  factory TournamentModel() => _model;

  static final _model = TournamentModel._internal();

  TournamentModel._internal();

  Map<int, Tournament> tournamentMap;

  Tournament select(int id) => tournamentMap[id];

  List<Tournament> get tournaments => tournamentMap.values.toList();
}
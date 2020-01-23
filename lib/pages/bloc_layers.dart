import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';

class VyktorBlocProvider extends StatelessWidget {
  final Widget child;

  VyktorBlocProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndependentBlocs(
      child: LocationBlocProvider(
        child: MarkerBlocProvider(
          child: TournamentBlocProvider(
            child: child,
          ),
        ),
      ),
    );
  }
}

class IndependentBlocs extends StatelessWidget {
  final Widget child;

  IndependentBlocs({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PermissionBloc>(create: (context) => PermissionBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        BlocProvider<PanelSelectorBloc>(
            create: (context) => PanelSelectorBloc()),
      ],
      child: child,
    );
  }
}

class LocationBlocProvider extends StatelessWidget {
  final Widget child;

  LocationBlocProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => LocationBloc(
          permissionBloc: BlocProvider.of<PermissionBloc>(context)),
      child: child,
    );
  }
}

class MarkerBlocProvider extends StatelessWidget {
  final Widget child;

  MarkerBlocProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MarkerBloc>(
      create: (context) => MarkerBloc(
          settingsBloc: BlocProvider.of<SettingsBloc>(context),
          locationBloc: BlocProvider.of<LocationBloc>(context)),
      child: child,
    );
  }
}

class TournamentBlocProvider extends StatelessWidget {
  final Widget child;

  TournamentBlocProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TournamentBloc>(
      create: (context) => TournamentBloc(
          markerBloc: BlocProvider.of<MarkerBloc>(context)),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';
import 'package:vyktor/services/unicorn_dial.dart';

class VyktorMenu extends StatefulWidget {
  VyktorMenu({Key key}) : super(key: key);

  VyktorMenuState createState() => VyktorMenuState();
}

class VyktorMenuState extends State<VyktorMenu> {

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    List<UnicornButton> childButtons = [
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.surface,
        labelText: "Map settings",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).backgroundColor,
          child: Icon(Icons.map),
          heroTag: "map",
          mini: true,
          onPressed: () async {
            mapBloc.dispatch(ToggleMapLocking());
          },
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.surface,
        labelText: "Search settings",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).backgroundColor,
          child: Icon(Icons.search),
          heroTag: "search",
          mini: true,
          onPressed: () async {
            mapBloc.dispatch(ToggleMapLocking());
          },
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.surface,
        labelText: "Other info",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).backgroundColor,
          child: Icon(Icons.info),
          heroTag: "info",
          mini: true,
          onPressed: () async {
            mapBloc.dispatch(ToggleMapLocking());
          },
        ),
      ),
    ];
    return Align(
      alignment: Alignment(0.9, 0.9),
      child: UnicornDialer(
        bottomPadding: 30.0,
        childButtons: childButtons,
        finalButtonIcon: Icon(Icons.launch),
        onMainButtonPressed: () async {
          mapBloc.dispatch(ToggleMapLocking());
        },
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.settings),
        parentButtonBackground: Theme.of(context).colorScheme.primaryVariant,
      ),
    );
  }
}

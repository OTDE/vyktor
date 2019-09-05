import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';
import 'package:vyktor/services/unicorn_dial.dart';

class VyktorMenu extends StatefulWidget {
  VyktorMenu({Key key}) : super(key: key);

  VyktorMenuState createState() => VyktorMenuState();
}

class VyktorMenuState extends State<VyktorMenu> {
  bool _mainButtonSelected = false;
  bool _inSelection = false;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    final animBloc = BlocProvider.of<AnimatorBloc>(context);
    List<UnicornButton> childButtons = [
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.primaryVariant,
        labelText: "Map Settings",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.map),
          heroTag: "map",
          mini: true,
          onPressed: () async {
            animBloc.dispatch(SelectMapSettings());
            _mainButtonSelected = false;
          },
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.primaryVariant,
        labelText: "Search Settings",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.search),
          heroTag: "search",
          mini: true,
          onPressed: () async {
            animBloc.dispatch(SelectSearchSettings());
            _mainButtonSelected = false;
          },
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.primaryVariant,
        labelText: "Other Info",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.info),
          heroTag: "info",
          mini: true,
          onPressed: () async {
            animBloc.dispatch(SelectInfo());
            _mainButtonSelected = false;
          },
        ),
      ),
    ];

    var menuDial = Align(
        alignment: Alignment(0.9, 0.9),
        child: UnicornDialer(
          bottomPadding: 15.0,
          rightPadding: 15.0,
          childButtons: childButtons,
          finalButtonIcon: Icon(Icons.cancel),
          onBackgroundPressed: () async {
            mapBloc.dispatch(UnlockMap());
            _mainButtonSelected = false;
          },
          onMainButtonPressed: () async {
            if (_inSelection) {
              return;
            }
            _inSelection = true;
            animBloc.dispatch(DeselectAll());
            if (_mainButtonSelected) {
              mapBloc.dispatch(UnlockMap());
              _mainButtonSelected = false;
            } else {
              mapBloc.dispatch(LockMap());
              _mainButtonSelected = true;
            }
            _inSelection = false;
          },
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.settings),
          parentButtonBackground: Theme.of(context).primaryColor,
          parentButtonForeground: Theme.of(context).colorScheme.onPrimary,
        ));
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      return (state is MapDataLoaded) ? menuDial : Container();
    });
  }
}

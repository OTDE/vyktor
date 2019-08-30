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
            print('hit map');
            mapBloc.dispatch(UnlockMap());
            _mainButtonSelected = false;
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
            print('hit search');
            mapBloc.dispatch(UnlockMap());
            _mainButtonSelected = false;
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
            print('hit info');
            mapBloc.dispatch(UnlockMap());
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
          finalButtonIcon: Icon(Icons.launch),
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
          parentButtonBackground:
          Theme.of(context).colorScheme.primaryVariant,
        ));
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            animBloc.dispatch(DeselectAll());
            mapBloc.dispatch(UnlockMap());
          },
          child: menuDial,
        )
      ],
    );
  }
}

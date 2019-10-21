import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../blocs/blocs.dart';
import '../services/services.dart';
import 'components.dart';

/// Vyktor's menu. Largely centered around the 'unicorn dial' code.
class VyktorMenu extends StatefulWidget {
  VyktorMenu({Key key}) : super(key: key);

  VyktorMenuState createState() => VyktorMenuState();
}

class VyktorMenuState extends State<VyktorMenu> {
  bool _isMainButtonSelected = false;
  bool _inSelectionFunction = false;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    List<UnicornButton> childButtons = [
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Theme.of(context).colorScheme.primaryVariant,
        labelText: "Refresh",
        labelTextStyle: Theme.of(context).primaryTextTheme.button,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.refresh),
          heroTag: "refresh",
          mini: true,
          onPressed: () async {
            MapLocker().unlock();
            if(await Settings().getExploreMode() == true) {
              mapBloc.dispatch(RefreshMarkerData());
            } else {
              var currentPosition = await Geolocator().getCurrentPosition();
              mapBloc.dispatch(RefreshMarkerData(currentPosition));
            }
            Loading().isNow(true);
            _isMainButtonSelected = false;
          },
        ),
      ),
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
            TabBehavior().setPanel(SelectedPanel.mapSettings);
            _isMainButtonSelected = false;
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
            TabBehavior().setPanel(SelectedPanel.searchSettings);
            _isMainButtonSelected = false;
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
            TabBehavior().setPanel(SelectedPanel.info);
            _isMainButtonSelected = false;
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
            MapLocker().unlock();
            _isMainButtonSelected = false;
          },
          onMainButtonPressed: () async {
            if (_inSelectionFunction) {
              return;
            }
            _inSelectionFunction = true;
            TabBehavior().setPanel(SelectedPanel.none);
            if (_isMainButtonSelected) {
              MapLocker().unlock();
              _isMainButtonSelected = false;
            } else {
              MapLocker().lock();
              _isMainButtonSelected = true;
            }
            _inSelectionFunction = false;
          },
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.settings),
          parentButtonBackground: Theme.of(context).primaryColor,
          parentButtonForeground: Theme.of(context).colorScheme.onPrimary,
        ));
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return (state is MapDataLoaded) ? menuDial : Container();
    });
  }
}
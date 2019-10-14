import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../blocs/blocs.dart';
import 'package:vyktor/services/singletons/tab_selector.dart';
import 'package:vyktor/services/singletons/settings.dart';

/// The panel dedicating to holding information search settings.
class SearchSettingsPanel extends StatefulWidget {
  @override
  _SearchSettingsPanelState createState() => _SearchSettingsPanelState();
}

class _SearchSettingsPanelState extends State<SearchSettingsPanel> {

  // These need to be initialized so the app doesn't throw a fit
  // while it's waiting for the settings to fill these values in.

  // The minimum date after which the tournament starts.
  int _startAfterDate = 0;
  // The maximum date before which a tournament starts.
  int _startBeforeDate = 0;
  bool _isExploreModeEnabled = false;
  TabBehavior _tabSelector = locator<TabBehavior>();

  @override
  void initState() {
    Settings().clear().then((e) {
      Settings().getStartAfterDate().then((afterDate) {
        Settings().getStartBeforeDate().then((beforeDate) {
          Settings().getExploreMode().then((exploreModeEnabled) {
            setState(() {
              _startAfterDate = afterDate;
              _startBeforeDate = beforeDate;
              _isExploreModeEnabled = exploreModeEnabled;
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Search settings',
              style: Theme.of(context).primaryTextTheme.display1,
            ),
            Spacer(flex: 1),
            Text(
              'Starts after:',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
            Spacer(flex: 1),
            Row(
              children: <Widget>[
                FloatingActionButton(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0.0,
                    heroTag: 'editAfterDate',
                    shape: ContinuousRectangleBorder(),
                    mini: true,
                    child: Icon(Icons.calendar_today),
                    onPressed: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(
                            _startAfterDate),
                        firstDate: DateTime.now().subtract(Duration(days: 1)),
                        lastDate:
                            DateTime.fromMillisecondsSinceEpoch(_startBeforeDate),
                      );
                      if(selectedDate == null) return;
                      _startAfterDate = selectedDate.millisecondsSinceEpoch;
                      await Settings().setStartBeforeDate(_startAfterDate);
                      mapBloc.dispatch(RefreshMarkerData());
                      setState(() {});
                    }),
                Spacer(flex: 1),
                Text(
                  '${_toFormattedDate(_startAfterDate)}',
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                Spacer(flex: 10),
              ],
            ),
            Spacer(flex: 1),
            Text(
              'Starts before:',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
            Spacer(flex: 1),
            Row(
              children: <Widget>[
                FloatingActionButton(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0.0,
                    heroTag: 'editBeforeDate',
                    shape: ContinuousRectangleBorder(),
                    mini: true,
                    child: Icon(Icons.calendar_today),
                    onPressed: () async {
                      // AfterDate picker invariant:
                      //
                      //
                      var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(
                            _startBeforeDate),
                        firstDate: DateTime.fromMillisecondsSinceEpoch(
                            _startAfterDate).add(Duration(days: 1)),
                        lastDate:
                            DateTime.fromMillisecondsSinceEpoch(_startAfterDate)
                                .add(Duration(days: 730)),
                      );
                      if(selectedDate == null) return;
                      _startBeforeDate = selectedDate.millisecondsSinceEpoch;
                      await Settings().setStartBeforeDate(_startBeforeDate);
                      mapBloc.dispatch(RefreshMarkerData());
                      setState(() {});
                    }),
                Spacer(flex: 1),
                Text(
                  '${_toFormattedDate(_startBeforeDate)}',
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                Spacer(flex: 10),
              ],
            ),
            Spacer(flex: 1),
            Row(
              children: <Widget>[
                Text(
                  'Explore mode:',
                  style: Theme.of(context).primaryTextTheme.headline,
                ),
                Spacer(flex: 1),
                Switch.adaptive(
                  value: _isExploreModeEnabled,
                  onChanged: (isEnabled) async {
                    if (isEnabled) {
                      mapBloc.dispatch(DisableLocationListening());
                    } else {
                      mapBloc.dispatch(EnableLocationListening());
                      var currentPosition = await Geolocator().getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                      );
                      mapBloc.dispatch(RefreshMarkerData(currentPosition));
                    }
                    await Settings().setExploreMode(isEnabled);
                    setState(() {
                      _isExploreModeEnabled = isEnabled;
                    });
                  },
                ),
              ],
            ),
            Spacer(flex: 1),
            Text(
              '(Press and hold on the map)',
              style: Theme.of(context).primaryTextTheme.caption,
            ),
            Spacer(flex: 20),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              elevation: 0.0,
              heroTag: 'cancelTournament',
              shape: ContinuousRectangleBorder(),
              mini: true,
              child: Icon(Icons.arrow_back),
              onPressed: () async {
                _tabSelector.setPanel(SelectedPanel.none);
                mapBloc.dispatch(UnlockMap());
              }),
        )
      ],
    );
  }

  /// Formats a unix [timestamp] into a mm/dd/yyyy date string.
  String _toFormattedDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.month}/${date.day}/${date.year}';
  }

}

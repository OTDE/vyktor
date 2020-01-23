import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../blocs.dart';

/// The [Bloc] that regulates the state of Vyktor's map data.
class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {

  final LocationBloc locationBloc;
  StreamSubscription _locationBlocSubscription;
  final SettingsBloc settingsBloc;

  /// Initial state of the BLoC is loading the data. Will switch to [MarkerDataNotLoaded]
  /// on failure and [MarkerDataLoaded] on success.
  @override
  MarkerState get initialState => MarkerDataLoading();

  /// On constructing this BLoC, it listens to a stream of the phone's position, and
  /// then fires a [RefreshMarkerData] event when it receives new data.
  MarkerBloc({@required this.settingsBloc, @required this.locationBloc}) {
    _locationBlocSubscription = locationBloc.listen((state) {
      if (state is LocationLoaded) {
       this.add(RefreshMarkerData());
      }
    });
  }

  /// On receiving an event, pushes a new state, depending on event type.
  @override
  Stream<MarkerState> mapEventToState(MarkerEvent event) async* {
      yield* _mapRefreshMarkerDataToState(state, event);
  }

  /// Uses input from the [RefreshMarkerData] event to stream [MapData].
  Stream<MarkerState> _mapRefreshMarkerDataToState(
      MarkerState state, RefreshMarkerData event) async* {
    Loading().isNow(true);
    if (locationBloc.state is LocationLoaded && settingsBloc.state is SettingsLoaded) {
      try {
        final markerData = await TournamentClient().fetchMarkerData(
          settings: settingsBloc.state,
          location: locationBloc.state,
        );
        Loading().isNow(false);
        yield MarkerDataLoaded(markerData);
      } catch(_) {
        Loading().isNow(false);
        yield MarkerDataNotLoaded();
      }
    }
    yield MarkerDataNotLoaded();
  }

}

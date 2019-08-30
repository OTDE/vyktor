import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vyktor/models/settings_data.dart';

class MapSettingsPanel extends StatefulWidget {
  @override
  _MapSettingsPanelState createState() => _MapSettingsPanelState();
}

class _MapSettingsPanelState extends State<MapSettingsPanel> {
  int _radius = 50;

  @override
  void initState() {
    Settings().getRadiusInMiles().then((value) {
      setState(() {
        _radius = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    final animBloc = BlocProvider.of<AnimatorBloc>(context);
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Map Settings',
              style: Theme.of(context).primaryTextTheme.display1,
            ),
            Spacer(flex: 1),
            Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: 200,
                  width: 260,
                  child: SizedBox(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 5.0),
                        ),
                        child: Center(
                          child: Container(
                            height: 180,
                            width: 240,
                            child: IgnorePointer(
                              child: GoogleMap(
                                circles: {
                                  Circle(
                                      center: LatLng(-44.493191 - 0.8, 168.446977 + 1.6),
                                      circleId: CircleId('radiusString'),
                                      radius: 1609.34 * _radius,
                                      fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
                                      strokeColor: Theme.of(context).colorScheme.primaryVariant,
                                      strokeWidth: 5,
                                  )
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(-44.493191, 168.446977),
                                  zoom: 4.8,
                                ),
                              ),
                            ),
                          ),
                        )),
                    height: 240,
                    width: 260,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  child: Text(
                    '${_radius.truncate()}',
                    style: Theme.of(context).primaryTextTheme.display4,
                  ),
                ),
                Positioned(
                  left: 17,
                  top: 75,
                  child: Text(
                    'miles',
                    style: Theme.of(context).primaryTextTheme.display1,
                  ),
                ),
              ],
            ),
            Spacer(flex: 1),
            Slider(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Theme.of(context).primaryColor,
              value: _radius.toDouble(),
              min: 5,
              max: 150,
              divisions: 58,
              onChanged: (value) {
                setState(() {
                  _radius = value.truncate();
                });
              },
            ),
            Spacer(flex: 7),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              foregroundColor: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              heroTag: 'cancelTournament',
              shape: ContinuousRectangleBorder(),
              mini: true,
              child: Icon(Icons.check),
              onPressed: () async {
                var currentPosition = await Geolocator().getCurrentPosition();
                await Settings().setRadiusInMiles(_radius);
                animBloc.dispatch(DeselectAll());
                mapBloc.dispatch(RefreshMarkerData(currentPosition));
                mapBloc.dispatch(UnlockMap());
              }),
        )
      ],
    );
  }

  /// Launches a [url]
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _toFormattedAddress(String address) {
    var addressWords = address.split(', ');
    return '${addressWords[0]}\n${addressWords[1]}, ${addressWords[2]}';
  }

  String _toFormattedDate(int timestamp) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return '${date.month}/${date.day}/${date.year} — ${date.hour % 12}:'
        '${(int minute) {
      return minute < 10 ? '0$minute' : '$minute';
    }(date.minute)} '
        '${(int hour) {
      return hour > 12 ? 'PM' : 'AM';
    }(date.hour)}';
  }

  String _buildSmashggURL(String slug) => 'http://smash.gg/' + slug;
}

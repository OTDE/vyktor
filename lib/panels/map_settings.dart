import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';
import '../models/tab_model.dart';
import '../services/settings.dart';

/// Panel dedicated to handling map settings.
class MapSettingsPanel extends StatefulWidget {
  @override
  _MapSettingsPanelState createState() => _MapSettingsPanelState();
}

class _MapSettingsPanelState extends State<MapSettingsPanel> {

  int _radius = 50;
  TabBehavior _tabSelector = locator<TabBehavior>();

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
    final mapBloc = BlocProvider.of<MapBloc>(context);
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
                            child: Align(
                              alignment: Alignment(0.4, 0.2),
                              child: IgnorePointer(
                                ignoring: true,
                                child: CustomPaint(
                                  painter: MapCircle(
                                    lineColor: Theme.of(context).colorScheme.secondary,
                                    radius: _radius.toDouble() / 2.5,
                                  ),
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
              onChanged: (radius) {
                setState(() {
                  _radius = radius.truncate();
                });
              },
              onChangeEnd: (radius) async {
                await Settings().setRadiusInMiles(radius.truncate());
              },
            ),
            Spacer(flex: 7),
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
              onPressed: () {
                _tabSelector.setPanel(SelectedPanel.none);
                mapBloc.dispatch(UnlockMap());
                mapBloc.dispatch(RefreshMarkerData());
              }),
        ),
      ],
    );
  }

}

class MapCircle extends CustomPainter {
  final Color lineColor;
  final double radius;
  Paint _paint;

  MapCircle({this.lineColor, this.radius}) {
    _paint = Paint()
        ..color = lineColor
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), radius, _paint);
  }

  @override
  bool shouldRepaint(MapCircle oldDelegate) => this.radius != oldDelegate.radius;
}

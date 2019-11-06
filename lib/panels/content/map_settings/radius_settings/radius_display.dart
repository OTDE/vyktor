import 'package:flutter/material.dart';

class RadiusDisplay extends StatelessWidget {

  final int radius;

  RadiusDisplay({this.radius});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          height: 150,
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
                      alignment: Alignment(0.5, 0.0),
                      child: IgnorePointer(
                        ignoring: true,
                        child: CustomPaint(
                          painter: MapCircle(
                            lineColor: Theme.of(context).colorScheme.secondary,
                            radius: radius.toDouble() / 2.75,
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
            '${radius.truncate()}',
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
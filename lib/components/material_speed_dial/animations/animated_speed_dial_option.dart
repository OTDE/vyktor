import 'package:flutter/material.dart';

class AnimatedSpeedDialOption extends AnimatedWidget {

  final Widget child;
  final double delay;

  AnimatedSpeedDialOption({
    Key key,
    Animation<double> listenable,
    this.child,
    this.delay,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: listenable,
        curve: Interval(delay, 1.0),
        reverseCurve: Interval(delay, 1.0),
      ),
      child: child,
    );

  }

}
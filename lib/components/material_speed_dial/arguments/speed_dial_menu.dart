import 'package:flutter/material.dart';

class SpeedDialMenu {

  final FloatingActionButton closedButton;
  final FloatingActionButton openButton;
  final AnimatedIconData animatedIcon;

  SpeedDialMenu({
    @required this.closedButton,
    this.openButton,
    this.animatedIcon,
  }) :  assert(closedButton != null, 'DialButton must have initial state.'),
        assert(closedButton.child != null || animatedIcon != null);

}
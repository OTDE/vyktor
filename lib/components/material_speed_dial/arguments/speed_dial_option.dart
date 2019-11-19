import 'package:flutter/material.dart';

class SpeedDialOption {

  final FloatingActionButton button;
  final MaterialButton label;

  SpeedDialOption({
    @required this.button,
    this.label,
  }) :  assert(button != null, 'Speed dial option must contain a button.'),
        assert(!button.isExtended, 'Speed dial option button cannot be extended.');

}


import 'package:flutter/material.dart';
import 'panels.dart';

class VyktorPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPanel(
      child: PanelFrame()
    );
  }
}

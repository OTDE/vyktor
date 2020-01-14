import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'panels.dart';
import '../blocs/blocs.dart';

class VyktorPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPanel(
      child: PanelFrame()
    );
  }
}

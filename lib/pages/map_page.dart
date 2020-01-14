import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class MapPage extends StatelessWidget {

  final Widget child;

  MapPage({this.child}) : super();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: BlocProvider.of<PanelSelectorBloc>(context).state is PanelSelected,
      child: child,
    );
  }
}

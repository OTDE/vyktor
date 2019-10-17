import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import 'package:vyktor/services/singletons/tab_selector.dart';

/// Utility widget designed to allow Vyktor's panels to be dismissed.
class ExitDetector extends StatefulWidget {
  @override
  _ExitDetectorState createState() => _ExitDetectorState();
}

class _ExitDetectorState extends State<ExitDetector> {


  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        mapBloc.dispatch(UnlockMap());
        TabBehavior().setPanel(SelectedPanel.none);
        await Future.delayed(Duration(seconds: 1));
        mapBloc.dispatch(UpdateSelectedTournament());
      },
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

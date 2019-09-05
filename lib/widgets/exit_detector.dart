import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';

class ExitDetector extends StatefulWidget {
  @override
  _ExitDetectorState createState() => _ExitDetectorState();
}

class _ExitDetectorState extends State<ExitDetector> {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    final animBloc = BlocProvider.of<AnimatorBloc>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        mapBloc.dispatch(UnlockMap());
        mapBloc.dispatch(UpdateSelectedTournament());
        animBloc.dispatch(DeselectAll());
      },
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

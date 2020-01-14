import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';

class ExitButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor:
          Theme.of(context).colorScheme.primaryVariant,
          elevation: 0.0,
          heroTag: 'cancel',
          shape: ContinuousRectangleBorder(),
          mini: true,
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            BlocProvider.of<PanelSelectorBloc>(context).add(HidePanel());
          }),
    );
  }
}

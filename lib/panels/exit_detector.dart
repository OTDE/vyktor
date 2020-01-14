import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

/// Utility widget designed to allow Vyktor's panels to be dismissed.
class ExitDetector extends StatelessWidget {

  const ExitDetector();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          BlocProvider.of<PanelSelectorBloc>(context).add(HidePanel());
        },
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

}

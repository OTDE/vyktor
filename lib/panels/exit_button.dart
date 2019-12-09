import 'package:flutter/material.dart';

import '../services/services.dart';

class ExitButton extends StatelessWidget {

  static final _locker = MapLocker();

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
            TabBehavior().setPanel(SelectedPanel.none);
            _locker.unlock();
          }),
    );
  }
}

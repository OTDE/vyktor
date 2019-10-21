import 'package:flutter/material.dart';

import '../services/services.dart';

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
          MapLocker().unlock();
          TabBehavior().setPanel(SelectedPanel.none);
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

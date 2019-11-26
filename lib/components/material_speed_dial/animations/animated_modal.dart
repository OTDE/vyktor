import 'package:flutter/material.dart';

class SpeedDialModal extends AnimatedWidget {

  final VoidCallback onTap;
  final bool isOpen;

  SpeedDialModal({
    Key key,
    Animation<double> listenable,
    this.onTap,
    this.isOpen
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: listenable,
        child: IgnorePointer(
          ignoring: !isOpen,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.black45.withOpacity(0.2),
            ),
          )
        )
    );
  }

}
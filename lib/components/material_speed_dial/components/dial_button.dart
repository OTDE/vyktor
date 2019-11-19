import 'package:flutter/material.dart';

class DialButton extends StatelessWidget {

  final FloatingActionButton button;
  final VoidCallback onClose;

  const DialButton({
    this.button,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return _buildFloatingActionButton(button);
  }


  Widget _buildFloatingActionButton(FloatingActionButton button) {
    return FloatingActionButton(
      key: button.key,
      child: button.child,
      tooltip: button.tooltip,
      heroTag: button.heroTag,
      onPressed: () {
        if (onClose != null) onClose();
        if (button.onPressed != null) button.onPressed();
      },
      mini: button.mini,
      clipBehavior: button.clipBehavior,
      focusNode: button.focusNode,
      autofocus: button.autofocus,
      materialTapTargetSize: button.materialTapTargetSize,
      isExtended: button.isExtended,
      backgroundColor: button.backgroundColor,
      disabledElevation: button.disabledElevation,
      elevation: button.elevation,
      focusColor: button.focusColor,
      focusElevation: button.focusElevation,
      foregroundColor: button.foregroundColor,
      highlightElevation: button.highlightElevation,
      hoverColor: button.hoverColor,
      hoverElevation: button.hoverElevation,
      shape: button.shape,
      splashColor: button.splashColor,
    );
  }

}

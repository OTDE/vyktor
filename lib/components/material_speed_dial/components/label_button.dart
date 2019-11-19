import 'package:flutter/material.dart';

class DialLabel extends StatelessWidget {

  final MaterialButton button;
  final VoidCallback onClose;

  const DialLabel({this.button, this.onClose});

  @override
  Widget build(BuildContext context) {
    return _buildButton(button);
  }

  Widget _buildButton(MaterialButton button) => MaterialButton(
        key: button.key,
        onPressed: () {
          if (onClose != null) onClose();
          button.onPressed();
        },
        onHighlightChanged: button.onHighlightChanged,
        textTheme: button.textTheme,
        textColor: button.textColor,
        disabledTextColor: button.disabledTextColor,
        color: button.color,
        disabledColor: button.disabledColor,
        focusColor: button.focusColor,
        hoverColor: button.hoverColor,
        highlightColor: button.highlightColor,
        splashColor: button.splashColor,
        colorBrightness: button.colorBrightness,
        elevation: button.elevation,
        focusElevation: button.focusElevation,
        hoverElevation: button.hoverElevation,
        highlightElevation: button.highlightElevation,
        disabledElevation: button.disabledElevation,
        padding: button.padding,
        shape: button.shape,
        clipBehavior: button.clipBehavior,
        focusNode: button.focusNode,
        autofocus: button.autofocus,
        materialTapTargetSize: button.materialTapTargetSize,
        animationDuration: button.animationDuration,
        minWidth: button.minWidth,
        height: button.height,
        child: button.child,
      );
}

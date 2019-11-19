import 'package:flutter/material.dart';

class AnimatedSpeedDialMenu extends AnimatedWidget {

  final FloatingActionButton closedButton;
  final FloatingActionButton openedButton;
  final AnimatedIconData animatedIcon;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final bool isOpen;
  final TickerProvider ticker;
  final Duration duration;

  const AnimatedSpeedDialMenu({
    Key key,
    Animation<double> listenable,
    this.closedButton,
    this.openedButton,
    this.animatedIcon,
    this.onOpen,
    this.onClose,
    this.isOpen,
    this.ticker,
    this.duration
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final fallbackTheme = Theme.of(context).floatingActionButtonTheme;
    final closedTheme = _themeOf(closedButton, fallbackTheme);
    final openedTheme = _themeOf(openedButton ?? closedButton, fallbackTheme);
    final selectedButton = isOpen ? openedButton ?? closedButton : closedButton;
    final theme = FloatingActionButtonThemeData.lerp(
        closedTheme, openedTheme, animation.value);
    return FloatingActionButton(
      key: selectedButton.key,
      child: AnimatedSize(
        alignment: Alignment.centerRight,
          child: animatedIcon != null ?
              AnimatedIcon(
                  icon: animatedIcon,
                  progress: animation,
              )
              : AnimatedCrossFade(
            firstChild: closedButton.child,
            secondChild: openedButton?.child ?? closedButton.child,
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: duration,
          ),
        curve: Curves.easeInOutCubic,
        duration: duration,
        vsync: ticker,
      ),
      tooltip: selectedButton.tooltip,
      foregroundColor: theme.foregroundColor,
      backgroundColor: theme.backgroundColor,
      focusColor: theme.focusColor,
      hoverColor: theme.hoverColor,
      splashColor: theme.splashColor,
      heroTag: selectedButton.heroTag,
      elevation: theme.elevation,
      focusElevation: theme.focusElevation,
      hoverElevation: theme.hoverElevation,
      highlightElevation: theme.highlightElevation,
      disabledElevation: theme.disabledElevation,
      onPressed: () {
        if (isOpen) {
          onClose();
        } else {
          onOpen();
        }
        if (selectedButton.onPressed != null) selectedButton.onPressed();
      },
      shape: theme.shape,
      clipBehavior: selectedButton.clipBehavior,
      focusNode: selectedButton.focusNode,
      autofocus: selectedButton.autofocus,
      materialTapTargetSize: selectedButton.materialTapTargetSize,
      isExtended: selectedButton.isExtended,
    );
  }

  FloatingActionButtonThemeData _themeOf(
      FloatingActionButton button, FloatingActionButtonThemeData fallback) {
    return fallback.copyWith(
      backgroundColor: button?.backgroundColor,
      disabledElevation: button?.disabledElevation,
      elevation: button?.elevation,
      focusColor: button?.focusColor,
      focusElevation: button?.focusElevation,
      foregroundColor: button?.foregroundColor,
      highlightElevation: button?.highlightElevation,
      hoverColor: button?.hoverColor,
      hoverElevation: button?.hoverElevation,
      shape: button?.shape,
      splashColor: button?.splashColor,
    );
  }
}

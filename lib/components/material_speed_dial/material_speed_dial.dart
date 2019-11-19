import 'package:flutter/material.dart';

import 'animations/animations.dart';
import 'arguments/arguments.dart';
import 'components/components.dart';

export 'animations/animations.dart';
export 'arguments/arguments.dart';
export 'components/components.dart';


class DialDuration {
  static const fast = 500;
  static const medium = 1000;
  static const slow = 1500;
}

class MaterialSpeedDial extends StatefulWidget {
  final ThemeData themeData;
  final SpeedDialMenu menu;
  final List<SpeedDialOption> options;
  final DialDirection dialDirection;
  final TextDirection labelDirection;
  final double menuPadding;
  final double optionPadding;
  final double labelPadding;
  final Duration duration;

  MaterialSpeedDial({
    this.themeData,
    this.menu,
    this.options,
    this.dialDirection = DialDirection.up,
    this.labelDirection = TextDirection.ltr,
    this.menuPadding = 10.0,
    this.optionPadding = 5.0,
    this.labelPadding = 5.0,
    this.duration
  });

  @override
  _MaterialSpeedDialState createState() => _MaterialSpeedDialState();
}

class _MaterialSpeedDialState extends State<MaterialSpeedDial>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? Duration(milliseconds: 200),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onOpen() {
    _toggleMenu();
    setState(() {
      _isOpen = true;
    });
  }

  void _onClose() {
    _toggleMenu();
    setState(() {
      _isOpen = false;
    });
  }

  void _toggleMenu() {
    if (!mounted) {
      return;
    }
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() => _controller.forward();

  void _closeMenu() => _controller.reverse();

  double _getDelayFromIndex(int index) => index * (1.0 / widget.options.length);

  Iterable<MapEntry<int, SpeedDialOption>> _enumerateOptions(
      Iterable<SpeedDialOption> options) sync* {
    int index = 0;
    for (SpeedDialOption option in options) {
      yield MapEntry(index, option);
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          SpeedDialModal(
            listenable: _animation,
            onTap: () async {
              widget.menu.openButton.onPressed();
              _onClose();
            },
            isOpen: _isOpen,
          ),
          CustomMultiChildLayout(
            delegate: _SpeedDialLayoutDelegate(
              dialDirection: widget.dialDirection,
              labelDirection: widget.labelDirection,
              menuPadding: widget.menuPadding,
              optionPadding: widget.optionPadding,
              labelPadding: widget.labelPadding,
              optionCount: widget.options?.length ?? 0,
            ),
            children: _buildLayoutChildren(),
          ),
        ],
      )
    );
  }

  List<Widget> _buildLayoutChildren() {
    return <Widget>[
      LayoutId(
        id: 'dial-menu',
        child: _buildMenu(),
      ),
      if (widget.options != null)
        for (MapEntry<int, SpeedDialOption> option
            in _enumerateOptions(widget.options)) ...[
          LayoutId(
            id: 'dial-option-${option.key}',
            child: _buildOption(option.key, option.value.button),
          ),
          if (option.value.label != null)
            LayoutId(
              id: 'dial-label-${option.key}',
              child: _buildOption(option.key, option.value.label),
            ),
        ],
    ];
  }

  Widget _buildMenu() {
    return AnimatedSpeedDialMenu(
      listenable: _animation,
      animatedIcon: widget.menu.animatedIcon,
      closedButton: widget.menu.closedButton,
      openedButton: widget.menu.openButton,
      onOpen: _onOpen,
      onClose: _onClose,
      isOpen: _isOpen,
      ticker: this,
      duration: widget.duration,
    );
  }

  Widget _buildOption(int index, Widget button) {
    return AnimatedSpeedDialOption(
      listenable: _animation,
      delay: _getDelayFromIndex(index),
      child: button is FloatingActionButton
          ? DialButton(
              button: button,
              onClose: _onClose,
            )
          : DialLabel(
              button: button,
              onClose: _onClose,
            ),
    );
  }
}

class _SpeedDialLayoutDelegate extends MultiChildLayoutDelegate {
  static const String dialMenuId = 'dial-menu';
  static const String dialOptionId = 'dial-option';
  static const String dialLabelId = 'dial-label';

  final DialDirection dialDirection;
  final TextDirection labelDirection;
  final double menuPadding;
  final double optionPadding;
  final double labelPadding;
  final int optionCount;

  Offset center;

  _SpeedDialLayoutDelegate({
    this.dialDirection,
    this.labelDirection,
    this.menuPadding,
    this.optionPadding,
    this.labelPadding,
    this.optionCount,
  });

  @override
  void performLayout(Size size) {

    final menuSize = layoutChild(dialMenuId, BoxConstraints.loose(size));
    center = Offset(
        size.width - (menuSize.width / 2 + 12.0),
        size.height - (menuSize.height / 2 + 15.0));
    center = center.translate(-menuSize.width / 2, -menuSize.height / 2);
    positionChild(dialMenuId, center);
    double dx = center.dx +
        (DialDirection.getHorizontalCoefficient(dialDirection) *
            (menuSize.width + menuPadding));
    double dy = center.dy +
        (DialDirection.getVerticalCoefficient(dialDirection) *
            (menuSize.height + menuPadding));

    for (int i = 0; i < optionCount; i++) {
      if (hasChild('$dialOptionId-$i')) {
        var optionSize =
            layoutChild('$dialOptionId-$i', BoxConstraints.loose(size));

        if (i == 0) {
          dx += DialDirection.isVertical(dialDirection)
              ? (menuSize.width - optionSize.width) / 2
              : 0;
          dy += DialDirection.isHorizontal(dialDirection)
              ? (menuSize.height - optionSize.height) / 2
              : 0;
        } else {
          dx += DialDirection.getHorizontalCoefficient(dialDirection) *
              ((optionSize.width / 2) + _getPaddingFromIndex(i));
          dy += DialDirection.getVerticalCoefficient(dialDirection) *
              ((optionSize.height / 2) + _getPaddingFromIndex(i));
        }

        positionChild('$dialOptionId-$i', Offset(dx, dy));

        if (hasChild('$dialLabelId-$i') &&
            DialDirection.isVertical(dialDirection)) {
          var labelSize = layoutChild('$dialLabelId-$i', BoxConstraints.loose(size));
          var horizontalOffset = _getLabelCoefficient() *
              (labelPadding + labelSize.width);
          positionChild('$dialLabelId-$i', Offset(dx + horizontalOffset, dy));
        }

        dx += DialDirection.getHorizontalCoefficient(dialDirection) *
            (optionSize.width / 2);
        dy += DialDirection.getVerticalCoefficient(dialDirection) *
            (optionSize.height / 2);
      }
    }
  }

  double _getPaddingFromIndex(int index) =>
      index == 0 ? menuPadding : optionPadding;

  int _getLabelCoefficient() => labelDirection == TextDirection.rtl ? -1 : 1;

  @override
  bool shouldRelayout(_SpeedDialLayoutDelegate oldDelegate) {
    return optionCount != oldDelegate.optionCount;
  }
}

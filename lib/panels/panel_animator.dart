import 'dart:async';

import 'package:flutter/material.dart';

import '../services/services.dart';
import 'panels.dart';

/// Animation wrapper for a [child] widget.
///
/// The [panel] spec determines if [child] is selected.
class AnimatedPanels extends StatefulWidget {

  @override
  _AnimatedPanelsState createState() => _AnimatedPanelsState();

}

class _AnimatedPanelsState extends State<AnimatedPanels>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _controller;
  bool _isSelected = false;
  SelectedPanel _selectedPanel;
  StreamSubscription<SelectedPanel> tabStream;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offset = Tween<Offset>(begin: Offset(-1.0, 0), end: Offset(-0.005, 0))
        .chain(new CurveTween(curve: Curves.easeInOutCubic))
        .animate(_controller);
    tabStream = TabBehavior().panelSubject.stream.listen((panel) {
      setState(() {
        _selectedPanel = panel;
      });
      _animatePanel(panel);
    });
  }

  @override
  void didUpdateWidget(AnimatedPanels oldWidget) {
    tabStream.cancel();
    tabStream = TabBehavior().panelSubject.stream.listen((panel) {
      setState(() {
        _selectedPanel = panel;
      });
      _animatePanel(panel);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tabStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        textDirection: TextDirection.ltr,
        position: _offset,
        child: PanelFrame(panel: _selectedPanel),
      );
  }

  _animatePanel(SelectedPanel selectedPanel) {
      _isSelected = selectedPanel != SelectedPanel.none;
      if (_isSelected) {
        if (!_controller.isAnimating && _controller.isDismissed) {
          _controller.forward();
        }
      } else {
        if (!_controller.isAnimating && _controller.isCompleted) {
          _controller.reverse();
        }
      }
    }

}

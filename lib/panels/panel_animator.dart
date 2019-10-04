import 'package:flutter/material.dart';

import '../models/tab_model.dart';
import 'exit_detector.dart';

import 'dart:async';

/// Animation wrapper for a [child] widget.
///
/// The [panel] spec determines if [child] is selected.
class PanelAnimator extends StatefulWidget {
  final Widget child;
  final SelectedPanel panel;
  final TabBehavior _tabSelector = locator<TabBehavior>();

  PanelAnimator({Key key, this.child, this.panel}) : super(key: key);

  @override
  PanelAnimatorState createState() => PanelAnimatorState();

}

class PanelAnimatorState extends State<PanelAnimator>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _controller;
  bool _isSelected = false;
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
    tabStream = widget._tabSelector.panelSubject.stream.listen((panel) {
      _animatePanel(panel);
    });
  }

  @override
  void didUpdateWidget(PanelAnimator oldWidget) {
    tabStream.cancel();
    tabStream = widget._tabSelector.panelSubject.stream.listen((panel) {
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
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ExitDetector(),
            ),
            Positioned(
              bottom: 15,
              child: SizedBox(
                width: 300,
                height: 400,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        blurRadius: 5,
                        offset: Offset.fromDirection(1, 2),
                      )
                    ],
                    shape: BoxShape.rectangle,
                  ),
                  position: DecorationPosition.background,
                  child: Container(
                    width: 300,
                    height: 400,
                    margin: EdgeInsets.all(20.0)
                        .add(EdgeInsets.fromLTRB(1, 0, 0, 0)),
                    child: widget.child,
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }

  _animatePanel(SelectedPanel selectedPanel) {
      _isSelected = selectedPanel == widget.panel;
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

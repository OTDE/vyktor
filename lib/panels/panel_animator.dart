import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

/// Animation wrapper for a [child] widget.
///
/// The [panel] spec determines if [child] is selected.
class AnimatedPanel extends StatefulWidget {

  final Widget child;

  AnimatedPanel({Key key, this.child}): super(key: key);

  @override
  _AnimatedPanelState createState() => _AnimatedPanelState();

}

class _AnimatedPanelState extends State<AnimatedPanel>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _controller;

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
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        textDirection: TextDirection.ltr,
        position: _offset,
        child: BlocListener<PanelSelectorBloc, PanelSelectorState>(
          listener: (context, state) {
            if (state is PanelHidden && _shouldHidePanel()) {
              _controller.reverse();
            } else if (state is PanelSelected && _shouldDisplayPanel()) {
              _controller.forward();
            }
          },
          child: widget.child,
        ),
      );
  }

  bool _isNotAnimating() => !_controller.isAnimating;

  bool _shouldDisplayPanel() => _isNotAnimating() && _controller.isDismissed;

  bool _shouldHidePanel() => _isNotAnimating() && _controller.isCompleted;

}

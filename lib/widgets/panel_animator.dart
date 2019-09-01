import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';
import 'package:vyktor/widgets/exit_detector.dart';



class PanelAnimator extends StatefulWidget {

  final Widget child;
  final SelectedPanel panel;
  PanelAnimator({Key key, this.child, this.panel}) : super(key: key);

  @override
  PanelAnimatorState createState() => PanelAnimatorState();
}

class PanelAnimatorState extends State<PanelAnimator>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _controller;
  bool _isSelected = false;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimatorBloc, AnimatorState>(builder: (context, state) {
      if (state is TabAnimatorState) {
        _isSelected = state.selectedPanel == widget.panel;
        if (_isSelected) {
          if(!_controller.isAnimating && _controller.isDismissed) {
            _controller.forward();
          }
        } else {
          if(!_controller.isAnimating && _controller.isCompleted) {
            _controller.reverse();
          }
        }
      }
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
    });
  }
}

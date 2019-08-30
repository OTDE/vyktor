import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';
import 'selected_tournament.dart';
import 'package:vyktor/widgets/exit_detector.dart';

class SelectedTournamentAnimator extends StatefulWidget {
  SelectedTournamentAnimator({Key key}) : super(key: key);

  @override
  SelectedTournamentAnimatorState createState() =>
      SelectedTournamentAnimatorState();
}

class SelectedTournamentAnimatorState extends State<SelectedTournamentAnimator>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _controller;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offset = Tween<Offset>(begin: Offset(-1.0, 0), end: Offset(-0.005, 0))
        .chain(new CurveTween(curve: Curves.ease))
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
        _isSelected = state.isTournamentSelected;
        if (_isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
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
                        shape: BoxShape.rectangle,
                      ),
                      position: DecorationPosition.background,
                      child: Container(
                        width: 300,
                        height: 300,
                        margin: EdgeInsets.all(20.0)
                            .add(EdgeInsets.fromLTRB(1, 0, 0, 0)),
                        child: SelectedTournament(),
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

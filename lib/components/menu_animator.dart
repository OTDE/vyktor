import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import 'components.dart';

/// Vyktor's menu. Largely centered around the 'unicorn dial' code.
class AnimatedMenu extends StatefulWidget {
  AnimatedMenu({Key key}) : super(key: key);

  _AnimatedMenuState createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      switchInCurve: Curves.linearToEaseOut,
      child: BlocBuilder<MarkerBloc, MarkerState>(builder: (context, state) {
        return (state is MarkerDataLoaded) ? Menu() : Container();
      }),
    );
  }

}

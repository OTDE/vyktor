import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../pages/pages.dart';
import '../services/services.dart';

import 'components.dart';

/// The page containing the map and its associated data.
class VyktorMap extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkerBloc, MarkerState>(builder: (context, state) {
      return AnimatedSwitcher(
        duration: Duration(seconds: 3),
        switchInCurve: Curves.linearToEaseOut,
        child: _getChildFromState(state),
      );
    });
  }

  Widget _getChildFromState(MarkerState state) {
    if(state is MarkerDataLoaded) {
      Future.delayed(Duration(seconds: 2), () {
        Loading().isNow(false);
      });
      return MapPage(child: LoadedMap());
    } else if (state is MarkerDataNotLoaded) {
      return ErrorPage();
    }
    return SizedBox.shrink();
  }

}

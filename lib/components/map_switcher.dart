import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../pages/pages.dart';
import '../services/services.dart';

/// The page containing the map and its associated data.
class VyktorMap extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return AnimatedSwitcher(
        duration: Duration(seconds: 3),
        switchInCurve: Curves.linearToEaseOut,
        child: _getChildFromState(state),
      );
    });
  }

  Widget _getChildFromState(MapState state) {
    if(state is MapDataLoaded) {
      Future.delayed(Duration(seconds: 2), () {
        Loading().isNow(false);
      });
      return MapPage();
    } else if (state is MapDataNotLoaded) {
      return ErrorPage();
    }
    return SizedBox.shrink();
  }

}

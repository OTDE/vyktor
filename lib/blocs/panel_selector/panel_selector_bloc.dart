import 'dart:async';

import 'package:bloc/bloc.dart';

import 'panel_selector.dart';

class PanelSelectorBloc extends Bloc<PanelSelectorEvent, PanelSelectorState> {
  @override
  PanelSelectorState get initialState => PanelHidden();

  @override
  Stream<PanelSelectorState> mapEventToState(PanelSelectorEvent event) async* {
    if (event is HidePanel) {
      yield PanelHidden();
    } else if (event is SelectPanel) {
      yield PanelSelected(event.panel);
    }
  }
}
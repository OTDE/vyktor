import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/blocs.dart';

import 'panels.dart';

class PanelFrame extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ExitDetector(),
        Positioned(
          bottom: 15,
          child: SizedBox(
            width: 300,
            height: 500,
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
                child: Stack(
                  children: <Widget>[
                      BlocBuilder<PanelSelectorBloc, PanelSelectorState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: _selectPanelFromState(state),
                          );
                        },
                    ),
                    ExitButton(),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _selectPanelFromState(PanelSelectorState state) {
    if (state is PanelSelected) return _fromPanel(state.panel);
    return SizedBox.shrink();
  }

  Widget _fromPanel(SelectedPanel panel) {
      switch (panel) {
        case SelectedPanel.tournament:
          return SelectedTournament();
        case SelectedPanel.mapSettings:
          return MapSettingsPanel();
        case SelectedPanel.searchSettings:
          return SearchSettingsPanel();
        case SelectedPanel.info:
          return InfoPanel();
      }
      return SizedBox.shrink();
  }
  
}

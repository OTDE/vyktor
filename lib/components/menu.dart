import 'package:flutter/material.dart';
import 'material_speed_dial/material_speed_dial.dart';
import '../services/services.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return MaterialSpeedDial(
      dialDirection: DialDirection.up,
      labelDirection: TextDirection.rtl,
      duration: Duration(milliseconds: 300),
      menuPadding: 10.0,
      optionPadding: 15.0,
      menu: SpeedDialMenu(
        animatedIcon: AnimatedIcons.menu_close,
        closedButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            heroTag: 'main-menu-open',
            onPressed: () async {
              MapLocker().lock();
            }
          ),
        openButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            heroTag: 'main-menu-closed',
            onPressed: () async {
              MapLocker().unlock();
            }
        )
      ),
      options: <SpeedDialOption>[
        for (SelectedPanel panel in SelectedPanel.values.sublist(1, 4).reversed)
          SpeedDialOption(
              button: FloatingActionButton(
                  child: Icon(withIconFrom(panel)),
                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  heroTag: panel.toString(),
                  mini: true,
                  onPressed: () async {
                    TabBehavior().setPanel(panel);
                  }
              ),
            label: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  labelFrom(panel),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                color: Theme.of(context).colorScheme.primaryVariant,
                onPressed: () async {
                  TabBehavior().setPanel(panel);
                }
            )
          ),
      ],
    );
  }

  IconData withIconFrom(SelectedPanel panel) {
    switch(panel) {
      case SelectedPanel.mapSettings:
        return Icons.map;
      case SelectedPanel.searchSettings:
        return Icons.search;
      case SelectedPanel.info:
        return Icons.info;
      default:
        return Icons.close;
    }
  }

  String labelFrom(SelectedPanel panel) {
    switch(panel) {
      case SelectedPanel.mapSettings:
        return 'Map Settings';
      case SelectedPanel.searchSettings:
        return 'Search Settings';
      case SelectedPanel.info:
        return 'Other Info';
      default:
        return '';
    }
  }
}

import 'package:rxdart/rxdart.dart';

enum SelectedPanel { tournament, mapSettings, searchSettings, info, none }

class TabBehavior {

  factory TabBehavior() => _tabBehavior;

  static final _tabBehavior = TabBehavior._internal();

  TabBehavior._internal();

  final panelSubject = BehaviorSubject<SelectedPanel>.seeded(SelectedPanel.none);

  void setPanel(SelectedPanel panel) => panelSubject.add(panel);

  void dispose() => panelSubject.close();

}



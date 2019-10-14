import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

enum SelectedPanel { tournament, mapSettings, searchSettings, info, none }

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerSingleton<TabBehavior>(TabBehavior());
}

class TabBehavior {

  final BehaviorSubject<SelectedPanel> panelSubject = BehaviorSubject<SelectedPanel>.seeded(SelectedPanel.none);

  void setPanel(SelectedPanel panel) => panelSubject.add(panel);

  void dispose() => panelSubject.close();

}



import 'package:rxdart/rxdart.dart';

enum SelectedPanel { tournament, mapSettings, searchSettings, info, none }

class TabBehavior {

  BehaviorSubject<SelectedPanel> panelSubject;

  static final TabBehavior _subject = TabBehavior._internal();

  TabBehavior._internal() {
    panelSubject = BehaviorSubject<SelectedPanel>();
    panelSubject.add(SelectedPanel.none);
  }

  factory TabBehavior() => _subject;

  void dispatch(SelectedPanel panel) => panelSubject.add(panel);

  void dispose() => panelSubject.close();

}

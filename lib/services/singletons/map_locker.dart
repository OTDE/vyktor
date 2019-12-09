import 'package:rxdart/rxdart.dart';

class MapLocker {

  factory MapLocker() => _locker;

  static final _locker = MapLocker._internal();

  MapLocker._internal();

  final isLocked = BehaviorSubject<bool>.seeded(false);

  lock() => isLocked.add(true);

  unlock() => isLocked.add(false);

  dispose() => isLocked.close();
}
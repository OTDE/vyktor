import 'package:rxdart/rxdart.dart';

class MapLocker {

  factory MapLocker() => _locker;

  static final _locker = MapLocker._internal();

  MapLocker._internal();

  final isLocked = BehaviorSubject<bool>.seeded(false);

  void lock() => isLocked.add(true);

  void unlock() => isLocked.add(false);

  void dispose() => isLocked.close();
}
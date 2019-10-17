import 'package:rxdart/rxdart.dart';

class Loading {

  factory Loading() => _loading;

  static final _loading = Loading._internal();

  Loading._internal();

  final isLoading = BehaviorSubject<bool>.seeded(false);

  void isNow(bool loading) => isLoading.add(loading);

  void dispose() => isLoading.close();
}
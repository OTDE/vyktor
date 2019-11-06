import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/services.dart';
import '../../../../theme.dart';
import 'date_window_filter_buttons.dart';

class DateWindowFilter extends StatefulWidget {
  @override
  _DateWindowFilterState createState() => _DateWindowFilterState();
}

class _DateWindowFilterState extends State<DateWindowFilter> {

  bool _loading = false;
  StreamSubscription<bool> _loadingListener;

  @override
  void initState() {
    _loadingListener = Loading().isLoading.stream.listen((bool loading) {
      setState(() {
        _loading = loading;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _loadingListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _loading,
      child: DateWindowFilterButtons(
        datePickerTheme: VyktorTheme.datePickerThemeBuilder,
      ),
    );
  }
}



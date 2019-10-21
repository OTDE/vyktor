import 'dart:async';

import 'package:flutter/material.dart';

import '../components/components.dart';
import '../services/services.dart';


class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  StreamSubscription<bool> _loadListener;
  bool _loading = false;

  @override
  void initState() {
    _loadListener = Loading().isLoading.stream.listen((bool loading) {
      setState(() {
        _loading = loading;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _loadListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        switchInCurve: Curves.elasticOut,
        switchOutCurve: Curves.elasticIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            child: child,
            scale: animation,
          );
        },
        child: _loading ? LoadingIcon() : Container(),
      ),
    );
  }
}

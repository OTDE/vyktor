import 'package:flutter/material.dart';
import '../services/singletons/loading.dart';

import 'dart:async';

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
        child: Container(
          key: ValueKey(_loading),
          width: _loading ? 60.0 : 0.0,
          height: _loading ? 60.0 : 0.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.primaryVariant,
              style: BorderStyle.solid,
              width: 4.0,
            ),
          ),
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/services.dart';

class LoadWrapper extends StatefulWidget {

  final Widget child;

  LoadWrapper({Key key, this.child}) : super(key: key);

  @override
  _LoadWrapperState createState() => _LoadWrapperState();
}

class _LoadWrapperState extends State<LoadWrapper> {

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
          child: widget.child,
        );
  }

}

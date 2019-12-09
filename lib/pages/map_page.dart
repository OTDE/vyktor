import 'dart:async';

import 'package:flutter/material.dart';

import '../components/components.dart';
import '../services/services.dart';

class MapPage extends StatefulWidget {

  final Widget child;

  MapPage({this.child}) : super();

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  StreamSubscription<bool> _mapLockListener;
  bool _isMapLocked = false;

  @override
  void initState() {
    _mapLockListener = MapLocker().isLocked.stream.listen((isLocked) {
      setState(() {
        _isMapLocked = isLocked;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mapLockListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isMapLocked,
      child: widget.child,
    );
  }
}

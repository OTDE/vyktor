import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vyktor/pages/pages.dart';
import '../blocs/blocs.dart';

class PageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionBloc, PermissionStatus>(
        builder: (context, state) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: state == PermissionStatus.granted
            ? HomePage()
            : PermissionPage(),
      );
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vyktor/blocs/delegate.dart';
import 'pages.dart';


class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocSupervisor.delegate = BasicBlocDelegate();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: Theme.of(context).primaryColor),
          VyktorBlocProvider(child: PageSwitcher()),
        ],
      ),
    );
  }
}


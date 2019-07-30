import 'package:flutter/material.dart';
import 'package:vyktor/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';

void main() => runApp(Vyktor());

/// TODO: Implement splash screen.
class Vyktor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyktor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        canvasColor: Colors.white,
      ),
      home: HomePage(title: 'Vyktor (Test mode)'),
    );
  }

}
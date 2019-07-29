import 'package:flutter/material.dart';
import 'package:vyktor/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';

void main() {
  runApp(
    BlocProvider(
      builder: (context) => MapDataBloc(),
      child: Vyktor(),
    ),
  );
}

/// TODO: Implement splash screen.
class Vyktor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyktor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Vyktor (Test mode)'),
    );
  }

}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/pages.dart';
import 'components/components.dart';
import 'services/services.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Storage().init();
  runApp(Vyktor());
}

/// The root widget of Vyktor.
class Vyktor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Set the status bar color.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: vyktorTheme.colorScheme.primary,
      statusBarColor: vyktorTheme.colorScheme.primary,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Vyktor',
      theme: vyktorTheme,
      home: Stack(
        children: <Widget>[
          HomePage(),
          LoadingIndicator(),
        ],
      ),
    );
  }

}

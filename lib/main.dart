import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/home_page.dart';
import 'services/storage.dart';
import 'theme.dart';

import 'dart:async';

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
      systemNavigationBarColor: vyktorTheme.colorScheme.primaryVariant,
      statusBarColor: vyktorTheme.colorScheme.primaryVariant,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Vyktor',
      theme: vyktorTheme,
      home: HomePage(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseExtension.init();
  runApp(Home());
}

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return CupertinoApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      initialRoute: '/',
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}

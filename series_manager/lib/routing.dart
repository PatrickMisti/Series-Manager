
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/detail.dart';
import 'package:series_manager/overview.dart';

class RouterGenerator  {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case "/":
        return CupertinoPageRoute(builder: (context) => Overview());
      case "/detail":
        return CupertinoPageRoute(builder: (context) => Detail(args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (context) =>
    Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Error"),
      ),
      body: Center(
        child: Text('Page not found!'),
      ),
    ));
  }
}
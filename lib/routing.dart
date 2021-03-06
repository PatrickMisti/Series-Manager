import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:series_manager/detail.dart';
import 'package:series_manager/overview.dart';
import 'package:series_manager/search.dart';

class RouterGenerator  {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case "/":
        return CupertinoPageRoute(builder: (context) => Overview());
      case "/detail":
        return CupertinoPageRoute(builder: (context) => Detail(args));
      case "/search":
        return PageTransition(child: Search(), type: PageTransitionType.fade);
        /*return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => Search(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );*/
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
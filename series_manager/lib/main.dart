import 'package:series_manager/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(Home());

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: buildAppBar(),
        body: Body(),
      ),
    );
  }
  AppBar buildAppBar(){
    return AppBar(
      title: Center(
        child: Text('Serien'),
      ),
      backgroundColor: Colors.green,
      elevation: 0,
    );
  }
}

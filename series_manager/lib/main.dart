import 'package:flutter/cupertino.dart';
import 'package:series_manager/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(Home());
final primaryColor = Colors.teal;

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: buildAppBar(),
          body: Body(),
        ),
      },
    );
  }
  AppBar buildAppBar(){
    return AppBar(
      toolbarHeight: 60,
      title: Container(
        height:  50,
        child: Stack(
          children: [
            Container(
              child: IconButton(
                icon: Icon(Icons.search,color: primaryColor),
                iconSize: 30,
                onPressed: null,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: primaryColor,
                    style: BorderStyle.solid,
                    width: 3
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              alignment: AlignmentDirectional.center,
              child: Text('Serien',
                style: TextStyle(
                    fontSize: 24,
                    color: primaryColor
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

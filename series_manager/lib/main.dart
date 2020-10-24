import 'package:flutter/cupertino.dart';
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
      title: Container(
        height: 50,
        child: Stack(
          children: [
            Container(
              child: IconButton(
                icon: Icon(Icons.search,color: Colors.black),
                iconSize: 30,
                onPressed: null,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Colors.black,
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
                    color: Colors.black
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

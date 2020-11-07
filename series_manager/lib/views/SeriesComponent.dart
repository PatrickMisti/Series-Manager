import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/data/entities/serie.dart';

class SeriesComponent extends StatelessWidget{
  SeriesComponent({Key key,@required this.series,@required this.size}):super(key:key);

  final Size size;
  final Series series;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              series.id.toString(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
              ),
            ),
          )
        ],
      ),
    );
  }
}
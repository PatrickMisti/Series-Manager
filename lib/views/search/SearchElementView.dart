import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/entities/serie.dart';

class SearchElementView extends StatelessWidget {
  final Series series;

  const SearchElementView({Key key, this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, "/detail", arguments: series),
        child: Container(
          color: Colors.tealAccent,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Image.memory(series.seriePhoto),
              Container(
                width: 250,
                child: Center(child: Text(series.name, style: TextStyle(fontSize: 20),maxLines: 3)),
                padding: EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
        ),
      )
    );
  }

}
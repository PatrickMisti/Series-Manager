import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/serie.dart';

class SeriesView extends StatelessWidget {
  final int _categoryId;

  SeriesView(this._categoryId);

  @override
  Widget build(BuildContext context) {
    int _indexOfItem = 0;
    return FutureBuilder(
      future: DataBaseExtension.getSeriesFromCategory(_categoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Series> seriesList = snapshot.data;
          return RotatedBox(
            quarterTurns: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/detail", arguments: seriesList[_indexOfItem]);
              },
              child: ListWheelScrollView(
                onSelectedItemChanged: (indexOfWheel) => _indexOfItem = indexOfWheel,
                diameterRatio: 5,
                itemExtent: 300,
                children: List<Widget>.generate(seriesList.length, (index) {
                  Series series = seriesList[index];
                  return new Container(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Column(
                        children: [
                          series.seriePhoto.isNotEmpty
                              ? Container(height: 200,width: 150, decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(series.seriePhoto))))
                              : Container(height: 200,width: 150, child: Center(child: Text("No Photo")),color: Colors.blue),
                          Text(series.name,style: TextStyle(color: Colors.teal),),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

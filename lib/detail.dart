import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/DetailManager.dart';
import 'package:series_manager/views/detail/SeriesAndMovieButtonView.dart';

class Detail extends StatefulWidget {
  final Series _series;

  const Detail(this._series);

  @override
  _Detail createState() => _Detail();
}

class _Detail extends State<Detail> {
  DetailManager _detailManager;

  deleteSeries() async {
    await DataBaseExtension.deleteSeriesAndCatSerFromId(widget._series.id);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _detailManager = new DetailManager(widget._series);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.teal,
        trailing: GestureDetector(
          onTap: () => deleteSeries(),
          child: Icon(Icons.delete, color: CupertinoColors.white,),
        ),
        middle: Text(widget._series.name, style: TextStyle(color: CupertinoColors.white)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: CupertinoColors.white,),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(image: MemoryImage(widget._series.seriePhoto))
            ),
          ),
          FutureBuilder(
            future: _detailManager.startFillingList(),
            builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return SeriesAndMovieButtonView(_detailManager);
            else
              return Container(child: Center(child: CupertinoActivityIndicator()));
          },)

        ],
      ),
    );
  }
}
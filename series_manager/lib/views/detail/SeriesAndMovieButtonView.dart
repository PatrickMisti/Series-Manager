import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/entities/manager.dart';
import 'package:series_manager/import/DetailManager.dart';
import 'package:series_manager/views/detail/HostedUrlToSeries.dart';
import 'package:series_manager/import/DetailManager.dart' hide ConvertListOfManagerSeason;

class SeriesAndMovieButtonView extends StatefulWidget {
  final DetailManager _detailManager;

  const   SeriesAndMovieButtonView(this._detailManager);

  @override
  _SeriesAndMovieButtonView createState() => _SeriesAndMovieButtonView();
}

class _SeriesAndMovieButtonView extends State<SeriesAndMovieButtonView> {
  /*initPicker(List season, String option) {
    var stats = widget.manager.getSerienManagerStats();
    if (option.compareTo("Filme") == 0 && stats["movie"] == null) return 0;
    if (option.compareTo("Serien") == 0 &&
        stats["episode"] == null &&
        stats["season"] == null)
      return 0;
    else
      return season.indexOf(widget.manager.currentEpisodeFromSeason());
  }*/

  showCupertinoSeriesAndSeasonPicker(List<ManagerSerie> video) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            key: UniqueKey(),
            color: CupertinoColors.white,
            height: 300,
            child: CupertinoPicker( //todo item index is wrong
                scrollController: FixedExtentScrollController(

                ),
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  setState(() {
                    widget._detailManager.setCurrentEpisode(video[index]);
                  });
                },
                children: new List<Widget>.generate(video.length,
                    (index) => Text(video[index].serieName))),
          );
        });
  }

  buildButtonForSeries(List<ManagerSeason> videos, String videoName) {
    return Expanded(
      key: UniqueKey(),
        child: CupertinoButton(
      onPressed: () {
        setState(() { //todo maybe update here because of picker element doubling
          if(videoName == "Movie" && widget._detailManager.getSeries.movie == 0)
            widget._detailManager.getSeries.setEpisode(1, 0, 0);
          if(videoName != "Movie" && widget._detailManager.getSeries.movie != 0)
            widget._detailManager.getSeries.setEpisode(0, 1, 1);
        });
        showCupertinoSeriesAndSeasonPicker(videos.convertToManagerSerieList());
      },
      child: Center(
        child: Text(
          videoName,
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
      ),
      color: Colors.teal,
      padding: EdgeInsets.all(10),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FutureBuilder(
            future: widget._detailManager.startFillingList(),
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    if (widget._detailManager.currentMovieList.isNotEmpty)
                      buildButtonForSeries(widget._detailManager.currentMovieList, "Movie"),
                    if ((widget._detailManager.currentMovieList.isNotEmpty &&
                        widget._detailManager.currentSeasonList.isNotEmpty))
                      SizedBox(
                        width: 20,
                      ),
                    if (widget._detailManager.currentSeasonList.isNotEmpty)
                      buildButtonForSeries(
                          widget._detailManager.currentSeasonList, "Series")
                  ],
                ),
              );
            },
          ),
          /*FutureBuilder(
            future: widget._detailManager.getHosterAndLanguageForSeries(),
            builder: (_, snapshot) => snapshot.hasData
                ? new HostedUrlToSeries(snapshot.data,widget._detailManager.getSerienManagerUrlFromSeries())
                : Center(
                    child: Text("No Output"),
                  ),
          ),*/
        ],
      ),
    );
  }
}

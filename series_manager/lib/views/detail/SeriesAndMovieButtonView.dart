import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/entities/manager.dart';
import 'package:series_manager/import/DetailManager.dart';
import 'package:series_manager/views/detail/HostedUrlToSeries.dart';
import 'package:series_manager/import/DetailManager.dart'
    hide ConvertListOfManagerSeason;

class SeriesAndMovieButtonView extends StatefulWidget {
  final DetailManager _detailManager;

  const SeriesAndMovieButtonView(this._detailManager);

  @override
  _SeriesAndMovieButtonView createState() => _SeriesAndMovieButtonView();
}

class _SeriesAndMovieButtonView extends State<SeriesAndMovieButtonView> {

  showCupertinoSeriesAndSeasonPicker(List<ManagerSerie> video) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            key: UniqueKey(),
            color: CupertinoColors.white,
            height: 300,
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: video.indexOf(video
                        .where((element) => element.episodeId == widget._detailManager.getCurrentEpisode().episodeId)
                        .first)),
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  setState(() {
                    widget._detailManager.setCurrentEpisode(video[index]);
                  });
                },
                children: new List<Widget>.generate(video.length, (index) => Text(video[index].serieName))),
          );
        });
  }

  buildButtonForSeries(List<ManagerSeason> videos, String videoName) {
    return Expanded(
        key: UniqueKey(),
        child: CupertinoButton(
          onPressed: () {
            setState(() {
              if (widget._detailManager.getSeries.movie == 0 && widget._detailManager.getSeries.season == 0)
                widget._detailManager.getSeries.setEpisode(0, 1, 1);
              if (videoName == "Movie" && widget._detailManager.getSeries.movie == 0)
                widget._detailManager.getSeries.setEpisode(1, 0, 0);
              if (videoName != "Movie" && widget._detailManager.getSeries.episode == 0)
                widget._detailManager.getSeries.setEpisode(0, 1, 1);
            });
            showCupertinoSeriesAndSeasonPicker(
                videos.convertToManagerSerieList());
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                if (widget._detailManager.currentMovieList.isNotEmpty)
                  buildButtonForSeries(widget._detailManager.currentMovieList, "Movie"),
                if ((widget._detailManager.currentMovieList.isNotEmpty && widget._detailManager.currentSeasonList.isNotEmpty))
                  SizedBox(width: 20),
                if (widget._detailManager.currentSeasonList.isNotEmpty)
                  buildButtonForSeries(widget._detailManager.currentSeasonList, "Series")
              ],
            )
          ),
          Container(
            child: FutureBuilder(
              future: widget._detailManager.getHosterAndLanguageForSeries(widget._detailManager.getCurrentEpisodeUrl()),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return snapshot.data != null
                      ? HostedUrlToSeries(snapshot.data, widget._detailManager.getSeries.video)
                      : Container(width: MediaQuery.of(context).size.height, child: Center(child: Text("No Element", style: TextStyle(color: CupertinoColors.white),)));
                else
                  return Container(width: MediaQuery.of(context).size.height, child: Center(child: CupertinoActivityIndicator()));
              }
            ),
          ),
        ],
      ),
    );
  }
}

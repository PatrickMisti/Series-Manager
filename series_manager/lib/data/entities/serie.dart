import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'series')
class Series {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String video;
  final Uint8List seriePhoto;
  int episode;
  int season;
  int movie;


  Series(this.id, this.name, this.video,this.seriePhoto,this.episode,this.season,this.movie);

  Series.fetching({this.id, this.name, this.video,this.seriePhoto,this.episode,this.season,this.movie});

  Series.fromSeries(List<dynamic> data, {this.id, this.name, this.seriePhoto,this.video,this.season,this.episode,this.movie});

  stringToMap() {
    return video.split('||');
  }

  setEpisode(int movie, int season, int episode) {
    this.movie = movie;
    this.season = season;
    this.episode = episode;
  }
}
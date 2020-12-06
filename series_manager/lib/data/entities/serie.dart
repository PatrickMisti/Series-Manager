import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'series')
class Series {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String video;
  final Uint8List seriePhoto;
  final int episode;
  final int season;
  final int movie;


  Series(this.id, this.name, this.video,this.seriePhoto,this.episode,this.season,this.movie);

  Series.fetching({this.id, this.name, this.video,this.seriePhoto,this.episode,this.season,this.movie});

  Series.fromSeries(List<dynamic> data, {this.id, this.name, this.seriePhoto,this.video,this.season,this.episode,this.movie});

  stringToMap() {
    return video.split('||');
  }
}
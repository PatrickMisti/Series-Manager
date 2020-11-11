import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'series')
class Series {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  String video;
  final Uint8List seriePhoto;
  final int episode;
  final int season;


  Series(this.id, this.name, this.video,this.seriePhoto,this.episode,this.season);

  Series.fetching({this.id, this.name, this.video,this.seriePhoto,this.episode,this.season});

  Series.fromSeries(List<dynamic> data, {this.id, this.name, this.seriePhoto,this.season,this.episode}){
    mapToString(data);
  }

  mapToString(List<dynamic> data) {
    video = data.join('||');
  }
  stringToMap() {
    return video.split('||');
  }
}
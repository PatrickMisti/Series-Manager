import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'series')
class Series {
  @primaryKey
  final int id;
  final String name;
  String video;
  final Uint8List photo;


  Series(this.id, this.name, this.video,this.photo);

  Series.fromSeries(List<dynamic> data, {this.id, this.name, this.photo}){
    mapToString(data);
  }

  mapToString(List<dynamic> data) {
    video = data.join('||');
  }
  stringToMap() {
    return video.split('||');
  }
}
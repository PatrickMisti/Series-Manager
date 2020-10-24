import 'package:floor/floor.dart';

@Entity(tableName: 'series')
class Series {
  @primaryKey
  final int id;
  final String name;
  String video;
  final int categoryId;


  Series(this.id, this.name, this.categoryId, this.video);

  Series.fromSeries(List<dynamic> data, {this.id, this.name,this.categoryId}){
    mapToString(data);
  }

  mapToString(List<dynamic> data) {
    video = data.join('||');
  }
  stringToMap() {
    return video.split('||');
  }
}
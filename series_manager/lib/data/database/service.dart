import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/categoryenum.dart';
import 'package:series_manager/data/entities/serie.dart';

class Service{

  getData(){
    return get();
  }
  getSeries() {
    return get()[1];
  }
  static getCategory() {
    return get()[0];
  }
  static get() {
    List<Category> category = [
      new Category(1,CategoryEnum.Adventure.toString()),
      new Category(2,CategoryEnum.Action.toString()),
      new Category(3,CategoryEnum.Action.toString()),
    ];
    final List<Series> series = [
      new Series.fromSeries(["Hasdflkölnsdfnöknasd"],
          id: 1,
          name:"One Outs",
          categoryId: 1
      ),
      new Series.fromSeries(["ljkasödfnönasdf"],
          id: 2,
          name:"Haikyuu!!",
          categoryId: 1
      ),
    ];
    List convert = new List();
    convert.add(category);
    convert.add(series);
    return convert;
  }
}

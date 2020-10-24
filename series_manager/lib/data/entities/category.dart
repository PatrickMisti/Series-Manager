import 'package:floor/floor.dart';
import 'package:series_manager/data/entities/categoryenum.dart';

@Entity(tableName: 'category')
class Category {
 @primaryKey
 int id;
 @ColumnInfo(name: 'categoriesEnum',nullable: false)
 String categoryEnum;


  Category(this.id,this.categoryEnum);

  Category.fromCategory(this.id,List<CategoryEnum> data,{this.categoryEnum = ''}){
  this.categoryEnum = data.join(',');
 }

  stringToMap(String data) {
    return categoryEnum.split(',');
  }
}
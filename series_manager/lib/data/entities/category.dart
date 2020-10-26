import 'package:floor/floor.dart';

@Entity(tableName: 'category')
class Category {
 @primaryKey
 final int id;
 @ColumnInfo(name: 'categoriesEnum',nullable: false)
 String categoryEnum;


  Category(this.id,this.categoryEnum);

  Category.fromCategory(this.id,this.categoryEnum){
   this.categoryEnum = this.categoryEnum.split('.')[1];
 }

  stringToMap(String data) {
    return categoryEnum.split(',');
  }
}
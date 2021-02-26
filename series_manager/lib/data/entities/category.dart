import 'package:floor/floor.dart';

@Entity(tableName: 'category')
class Category {
 @PrimaryKey(autoGenerate: true)
 int id;
 @ColumnInfo(name: 'categoriesName',nullable: false)
 String categoryName;


  Category(this.id,this.categoryName);

  Category.fetching({this.id,this.categoryName});

  Category.fromCategory(this.id,this.categoryName){
   this.categoryName = this.categoryName.split('.')[1];
 }

  stringToMap(String data) {
    return categoryName.split(',');
  }
}
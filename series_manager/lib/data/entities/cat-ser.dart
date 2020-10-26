
import 'package:floor/floor.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

@Entity(tableName: 'categoryseries',
    foreignKeys: [
      ForeignKey(childColumns: ['category_id'], parentColumns: ['id'], entity: Category),
      ForeignKey(childColumns: ['series_id'], parentColumns: ['id'], entity: Series)
    ])
class CategorySeries {
  @primaryKey
  final int id;
  @ColumnInfo(name: 'category_id')
  final int categoryId;
  @ColumnInfo(name: 'series_id')
  final int seriesId;

  CategorySeries(this.id, this.categoryId, this.seriesId);
}
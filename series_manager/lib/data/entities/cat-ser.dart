import 'package:floor/floor.dart';

@Entity(tableName: 'categoryseries')
    /*foreignKeys: [
      ForeignKey(childColumns: ['category_id'], parentColumns: ['id'], entity: Category),
      ForeignKey(childColumns: ['series_id'], parentColumns: ['id'], entity: Series)
    ])*/
class CategorySeries {
  @PrimaryKey(autoGenerate: true)
  final int id;
  @ColumnInfo(name: 'category_id')
  final int categoryId;
  @ColumnInfo(name: 'series_id')
  final int seriesId;

  CategorySeries(this.id, this.categoryId, this.seriesId);

  CategorySeries.fetching({this.id, this.categoryId, this.seriesId});
}
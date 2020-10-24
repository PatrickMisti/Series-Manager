import 'package:floor/floor.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

@dao
abstract class CategoryDao{
  @Query('Select * from Category')
  Future<List<Category>> findAllCategories();

  @Query('Select * from Category where id == :id')
  Stream<Category> getCategoryById(int id);

  @insert
  Future<void> insertCategory(Category category);

  @Query('Delete from Category where id = :id')
  Future<void> deleteCategory(int id);

  @Query('Delete from Category')
  Future<void> deleteAllCategories();
}

@dao
abstract class SeriesDao{

  @Query('Select * from Series')
  Future<List<Series>> findAllSeries();

  @Query('Select * from Series')
  Stream<Series> getSeriesById();

  @insert
  Future<void> insertSeries(Series series);

  @Query('Delete from Series where id = :id')
  Future<void> deleteSeries(int id);

  @Query('Delete from Series')
  Future<void> deleteAllSeries();
}
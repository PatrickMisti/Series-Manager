import 'package:floor/floor.dart';
import 'package:series_manager/data/entities/cat-ser.dart';
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

  @update
  Future<void> updateCategory(Category category);

  @Query('Delete from Category where id = :id')
  Future<void> deleteCategory(int id);

  @Query('Delete from Category')
  Future<void> deleteAllCategories();
}

@dao
abstract class SeriesDao{

  @Query('Select * from Series')
  Future<List<Series>> findAllSeries();

  @Query('Select * from Series where id = :id')
  Stream<Series> getSeriesById(int id);

  @insert
  Future<void> insertSeries(Series series);

  @update
  Future<void> updateSeries(Series series);

  @Query('Delete from Series where id = :id')
  Future<void> deleteSeries(int id);

  @Query('Delete from Series')
  Future<void> deleteAllSeries();
}

@dao
abstract class CategorySeriesDao{

  @Query('Select * from CategorySeries')
  Future<List<CategorySeries>> findAllCategorySeries();

  @Query('Select * from CategorySeries where id = :id')
  Stream<CategorySeries> getCategorySeriesById(int id);

  @insert
  Future<void> insertCategorySeries(CategorySeries categorySeries);

  @update
  Future<void> updateCategorySeries(CategorySeries categorySeries);

  @Query('Delete from CategorySeries where id = :id')
  Future<void> deleteCategorySeries(int id);

  @Query('Delete from CategorySeries')
  Future<void> deleteAllCategorySeries();
}
import 'package:floor/floor.dart';
import 'package:series_manager/data/entities/cat-ser.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

@dao
abstract class CategoryDao{
  @Query('Select * from Category')
  Future<List<Category>> findAllCategories();

  @Query('Select * from Category where id == :id')
  Future<Category> getCategoryById(int id);

  @insert
  Future<int> insertCategory(Category category);

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
  Future<Series> getSeriesById(int id);

  @insert
  Future<int> insertSeries(Series series);

  @update
  Future<void> updateSeries(Series series);

  @Query('Delete from Series where id = :id')
  Future<void> deleteSeries(int id);

  @Query('Delete from Series')
  Future<void> deleteAllSeries();

  @Query('Select s.* from CategorySeries cs left outer join series s on s.id = cs.series_id where cs.category_id = :id')
  Future<List<Series>> getSeriesFromCategory(int id);

  @Query('Select * from Series where video = :video')
  Future<List<Series>> getSeriesFromUrlCompare(String video);

  @Query('Select * from Series where name Like :input')
  Future<List<Series>> findSeriesByName(String input);

  @Query('DELETE cs,ser FROM categoryseries cs LEFT JOIN series ser on cs.series_id = ser.id WHERE ser.id = :id')
  Future<void> deleteSeriesAndCatSerFromId(int id);
}

@dao
abstract class CategorySeriesDao{

  @Query('Select * from CategorySeries')
  Future<List<CategorySeries>> findAllCategorySeries();

  @Query('Select * from CategorySeries where id = :id')
  Future<CategorySeries> getCategorySeriesById(int id);

  @Query('Select * from CategorySeries where series_Id = :seriesId')
  Future<List<CategorySeries>> getCategoryFromSeriesId(int seriesId);

  @Query('Select * from CategorySeries where category_Id = :categoryId')
  Future<List<CategorySeries>> getSeriesFromCategoryId(int categoryId);

  @insert
  Future<int> insertCategorySeries(CategorySeries categorySeries);

  @update
  Future<void> updateCategorySeries(CategorySeries categorySeries);

  @Query('Delete from CategorySeries where id = :id')
  Future<void> deleteCategorySeries(int id);

  @Query('Delete from CategorySeries')
  Future<void> deleteAllCategorySeries();
}
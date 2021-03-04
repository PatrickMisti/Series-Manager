import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/cat-ser.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

class DataBaseExtension {
  static AppDatabase _db;

  static init() async {
    _db = await $FloorAppDatabase.databaseBuilder('managerV2.db').build();
    //_db = await $FloorAppDatabase.inMemoryDatabaseBuilder().build(); // for testing
  }

  static Future<List> getAll<T>() async {
    if (T == Series) {
      return await _db.seriesDao.findAllSeries();
    } else if (T == Category) {
      return await _db.categoryDao.findAllCategories();
    } else if (T == CategorySeries) {
      return await _db.categorySeriesDao.findAllCategorySeries();
    }
    return null;
  }

  static Future<dynamic> findById<T>(int entityId) async {
    if (T == Series) {
      return await _db.seriesDao.getSeriesById(entityId);
    } else if (T == Category) {
      return await _db.categoryDao.getCategoryById(entityId);
    } else if (T == CategorySeries) {
      return await _db.categorySeriesDao.getCategorySeriesById(entityId);
    }
  }

  static Future<int> insert<T>(T entity) async {
    if (entity is Series) {
      return await _db.seriesDao.insertSeries(entity);
    } else if (entity is Category) {
      return await _db.categoryDao.insertCategory(entity);
    } else if (entity is CategorySeries) {
      return await _db.categorySeriesDao.insertCategorySeries(entity);
    }else{
      return null;
    }
  }

  static Future update<T>(T entity) async {
    if (entity is Series) {
      await _db.seriesDao.updateSeries(entity);
    } else if (entity is Category) {
      await _db.categoryDao.updateCategory(entity);
    } else if (entity is CategorySeries) {
      await _db.categorySeriesDao.updateCategorySeries(entity);
    }
  }

  static Future deleteById<T>(int entityId) async {
    if (T == Series) {
      await _db.seriesDao.deleteSeries(entityId);
    } else if (T == Category) {
      await _db.categoryDao.deleteCategory(entityId);
    } else if (T == CategorySeries) {
      await _db.categorySeriesDao.deleteCategorySeries(entityId);
    }
  }

  static Future deleteAll<T>() async {
    if (T == Series) {
      await _db.seriesDao.deleteAllSeries();
    } else if (T == Category) {
      await _db.categoryDao.deleteAllCategories();
    } else if (T == CategorySeries) {
      await _db.categorySeriesDao.deleteAllCategorySeries();
    }
  }

  static Future<List<Series>> findSeriesByName(String name) async {
    return await _db.seriesDao.findSeriesByName(name);
  }

  static Future<List<Series>> getSeriesFromCategory(int categoryId) async {
    return await _db.seriesDao.getSeriesFromCategory(categoryId);
  }

  static Future<List<Series>> getComparedOfSeriesUrl(String url) async {
    return await _db.seriesDao.getSeriesFromUrlCompare(url);
  }

  static Future<List<Series>> getSeriesFromCategoryId(int categoryId) async {
    List<CategorySeries> raw = await _db.categorySeriesDao.getSeriesFromCategoryId(categoryId);
    List<Series> result = new List<Series>();
    for(CategorySeries element in raw) {
      Series series = await _db.seriesDao.getSeriesById(element.seriesId);
      result.add(series);
    }
    return result;
  }

  static Future<List<CategorySeries>> getCategoryFromSeries(int seriesId) async {
    return await _db.categorySeriesDao.getCategoryFromSeriesId(seriesId);
  }

  static Future saveCategoriesToSeries(
      int episodeId, List<Category> categories) async {
    categories.forEach((element) async => await insert<CategorySeries>(
        new CategorySeries(null, element.id, episodeId)));
  }

  static dispose() async => await _db.close();

  static deleteDB() {
    _db.database.delete('categoryseries');
    _db.database.delete('series');
    _db.database.delete('category');

  }
}

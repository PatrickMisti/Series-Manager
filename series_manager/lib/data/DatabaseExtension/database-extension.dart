import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/cat-ser.dart';
import 'package:series_manager/data/entities/category.dart';

import 'package:series_manager/data/entities/serie.dart';

class DataBaseExtension{
  var _dbCategory;
  var _dbSeries;
  var _dbCategorySeries;

  DataBaseExtension() {
    _dbCategory = $FloorAppDatabase.databaseBuilder('category').build();
    _dbSeries = $FloorAppDatabase.databaseBuilder('series').build();
    _dbCategorySeries = $FloorAppDatabase.databaseBuilder('categoryseries').build();
  }

   getAll<T>() async{
    if(T == Series){
      return await _dbSeries.then((value) => value.seriesDao).then((value) => value.findAllSeries());
    }
    else if(T == Category){
      return await _dbCategory.then((value) => value.categoryDao).then((value) => value.findAllCategories());
    }
    else if(T == CategorySeries){
      return await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.findAllCategorySeries());
    }
  }
  findById<T>(int entityId) async{
    if(T == Series){
      return await _dbSeries.then((value) => value.seriesDao).then((value) => value.getSeriesById(entityId));
    }
    else if(T == Category) {
      return await _dbCategory.then((value) => value.categoryDao).then((value) => value.getCategoryById(entityId));
    }
    else if(T == CategorySeries){
      return await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.getCategorySeriesById(entityId));
    }
  }

  insert<T>(T entity) async{
    if(T == Series){
      await _dbSeries.then((value) => value.seriesDao).then((value) => value.insertSeries(entity as Series));
    }
    else if(T == Category) {
      await _dbCategory.then((value) => value.categoryDao).then((value) => value.insertCategory(entity as Category));
    }
    else if(T == CategorySeries){
      await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.insertCategorySeries(entity as CategorySeries));
    }
  }

  update<T>(T entity) async{
    if(T == Series){
      await _dbSeries.then((value) => value.seriesDao).then((value) => value.updateSeries(entity as Series));
    }
    else if(T == Category) {
      await _dbCategory.then((value) => value.categoryDao).then((value) => value.updateCategory(entity as Category));
    }
    else if(T == CategorySeries){
      await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.updateCategorySeries(entity as CategorySeries));
    }
  }

  deleteById<T>(int entityId) async{
    if(T == Series){
      await _dbSeries.then((value) => value.seriesDao).then((value) => value.deleteSeries(entityId));
    }
    else if(T == Category) {
      await _dbCategory.then((value) => value.categoryDao).then((value) => value.deleteCategory(entityId));
    }
    else if(T == CategorySeries){
      await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.deleteCategorySeries(entityId));
    }
  }
  deleteAll<T>() async{
    if(T == Series){
      await _dbSeries.then((value) => value.seriesDao).then((value) => value.deleteAllSeries());
    }
    else if(T == Category) {
      await _dbCategory.then((value) => value.categoryDao).then((value) => value.deleteAllCategories());
    }
    else if(T == CategorySeries){
      await _dbCategorySeries.then((value) => value.categorySeriesDao).then((value) => value.deleteAllCategorySeries());
    }
  }
  getSeriesFromCategory(int categoryId) async {
    List<CategorySeries> allCategories = await this.getAll<CategorySeries>();
    var currentCategoryFromId = allCategories.where((element) => element.categoryId == categoryId);
    var i = currentCategoryFromId.map((element) => this.findById<Series>(element.seriesId));
    return i;
  }
}
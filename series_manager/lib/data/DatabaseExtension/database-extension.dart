import 'package:flutter/material.dart';
import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/cat-ser.dart';
import 'package:series_manager/data/entities/category.dart';

import 'package:series_manager/data/entities/serie.dart';

class DataBaseExtension{
  static AppDatabase _db;

   static init() async {
     _db = await $FloorAppDatabase.databaseBuilder('manager.db').build();
     //_db = await $FloorAppDatabase.inMemoryDatabaseBuilder().build(); // for testing
  }

  static getAll<T>() async{
    if(T == Series){
      return await _db.seriesDao.findAllSeries();
    }
    else if(T == Category){
      return await _db.categoryDao.findAllCategories();
    }
    else if(T == CategorySeries){
      return await _db.categorySeriesDao.findAllCategorySeries();
    }
  }

  static findById<T>(int entityId) async{
    if(T == Series){
      return await _db.seriesDao.getSeriesById(entityId);
    }
    else if(T == Category) {
      return await _db.categoryDao.getCategoryById(entityId);
    }
    else if(T == CategorySeries){
      return await _db.categorySeriesDao.getCategorySeriesById(entityId);
    }
  }

  static insert<T>(T entity) async{
    if(entity is Series){
      return await _db.seriesDao.insertSeries(entity);
    }
    else if(entity is Category) {
      return await _db.categoryDao.insertCategory(entity);
    }
    else if(entity is CategorySeries){
      return await _db.categorySeriesDao.insertCategorySeries(entity);
    }
  }

  static update<T>(T entity) async{
    if(entity is Series){
      await _db.seriesDao.updateSeries(entity);
    }
    else if(entity is Category) {
      await _db.categoryDao.updateCategory(entity);
    }
    else if(entity is CategorySeries){
      await _db.categorySeriesDao.updateCategorySeries(entity);
    }
  }

  static deleteById<T>(int entityId) async{
    if(T == Series){
      await _db.seriesDao.deleteSeries(entityId);
    }
    else if(T == Category) {
      await _db.categoryDao.deleteCategory(entityId);
    }
    else if(T == CategorySeries){
      await _db.categorySeriesDao.deleteCategorySeries(entityId);
    }
  }

  static deleteAll<T>() async{
    if(T == Series){
      await _db.seriesDao.deleteAllSeries();
    }
    else if(T == Category) {
      await _db.categoryDao.deleteAllCategories();
    }
    else if(T == CategorySeries){
      await _db.categorySeriesDao.deleteAllCategorySeries();
    }
  }

  static getSeriesFromCategory(int categoryId) async {
    return _db.categorySeriesDao.getSeriesFromCategoryId(categoryId);
  }

  static getCategoryFromSeries(int seriesId) async {
     return _db.categorySeriesDao.getCategoryFromSeriesId(seriesId);
  }

  static dispose() async => await _db.close();
}
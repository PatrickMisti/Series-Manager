import 'dart:async';

import 'package:floor/floor.dart';
import 'package:series_manager/data/database/dao.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
part 'appDatabase.g.dart';

@Database(version: 1, entities: [Category,Series])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  SeriesDao get seriesDao;
}

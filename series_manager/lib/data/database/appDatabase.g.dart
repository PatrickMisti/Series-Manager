// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao _categoryDaoInstance;

  SeriesDao _seriesDaoInstance;

  CategorySeriesDao _categorySeriesDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `categoriesName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `series` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `video` TEXT, `seriePhoto` BLOB, `episode` INTEGER, `season` INTEGER, `movie` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categoryseries` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_id` INTEGER, `series_id` INTEGER, FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`series_id`) REFERENCES `series` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  SeriesDao get seriesDao {
    return _seriesDaoInstance ??= _$SeriesDao(database, changeListener);
  }

  @override
  CategorySeriesDao get categorySeriesDao {
    return _categorySeriesDaoInstance ??=
        _$CategorySeriesDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'category',
            (Category item) => <String, dynamic>{
                  'id': item.id,
                  'categoriesName': item.categoryName
                }),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'category',
            ['id'],
            (Category item) => <String, dynamic>{
                  'id': item.id,
                  'categoriesName': item.categoryName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _categoryMapper = (Map<String, dynamic> row) =>
      Category(row['id'] as int, row['categoriesName'] as String);

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  @override
  Future<List<Category>> findAllCategories() async {
    return _queryAdapter.queryList('Select * from Category',
        mapper: _categoryMapper);
  }

  @override
  Future<Category> getCategoryById(int id) async {
    return _queryAdapter.query('Select * from Category where id == ?',
        arguments: <dynamic>[id], mapper: _categoryMapper);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _queryAdapter.queryNoReturn('Delete from Category where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> deleteAllCategories() async {
    await _queryAdapter.queryNoReturn('Delete from Category');
  }

  @override
  Future<int> insertCategory(Category category) {
    return _categoryInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _categoryUpdateAdapter.update(category, OnConflictStrategy.abort);
  }
}

class _$SeriesDao extends SeriesDao {
  _$SeriesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _seriesInsertionAdapter = InsertionAdapter(
            database,
            'series',
            (Series item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'video': item.video,
                  'seriePhoto': item.seriePhoto,
                  'episode': item.episode,
                  'season': item.season,
                  'movie': item.movie
                }),
        _seriesUpdateAdapter = UpdateAdapter(
            database,
            'series',
            ['id'],
            (Series item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'video': item.video,
                  'seriePhoto': item.seriePhoto,
                  'episode': item.episode,
                  'season': item.season,
                  'movie': item.movie
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _seriesMapper = (Map<String, dynamic> row) => Series(
      row['id'] as int,
      row['name'] as String,
      row['video'] as String,
      row['seriePhoto'] as Uint8List,
      row['episode'] as int,
      row['season'] as int,
      row['movie'] as int);

  final InsertionAdapter<Series> _seriesInsertionAdapter;

  final UpdateAdapter<Series> _seriesUpdateAdapter;

  @override
  Future<List<Series>> findAllSeries() async {
    return _queryAdapter.queryList('Select * from Series',
        mapper: _seriesMapper);
  }

  @override
  Future<Series> getSeriesById(int id) async {
    return _queryAdapter.query('Select * from Series where id = ?',
        arguments: <dynamic>[id], mapper: _seriesMapper);
  }

  @override
  Future<void> deleteSeries(int id) async {
    await _queryAdapter.queryNoReturn('Delete from Series where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> deleteAllSeries() async {
    await _queryAdapter.queryNoReturn('Delete from Series');
  }

  @override
  Future<List<Series>> getSeriesFromCategory(int id) async {
    return _queryAdapter.queryList(
        'Select s.* from CategorySeries cs left outer join series s on s.id = cs.series_id where cs.category_id = ?',
        arguments: <dynamic>[id],
        mapper: _seriesMapper);
  }

  @override
  Future<List<Series>> getSeriesFromUrlCompare(String video) async {
    return _queryAdapter.queryList('Select * from Series where video = ?',
        arguments: <dynamic>[video], mapper: _seriesMapper);
  }

  @override
  Future<int> insertSeries(Series series) {
    return _seriesInsertionAdapter.insertAndReturnId(
        series, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSeries(Series series) async {
    await _seriesUpdateAdapter.update(series, OnConflictStrategy.abort);
  }
}

class _$CategorySeriesDao extends CategorySeriesDao {
  _$CategorySeriesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categorySeriesInsertionAdapter = InsertionAdapter(
            database,
            'categoryseries',
            (CategorySeries item) => <String, dynamic>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'series_id': item.seriesId
                }),
        _categorySeriesUpdateAdapter = UpdateAdapter(
            database,
            'categoryseries',
            ['id'],
            (CategorySeries item) => <String, dynamic>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'series_id': item.seriesId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _categoryseriesMapper = (Map<String, dynamic> row) =>
      CategorySeries(
          row['id'] as int, row['category_id'] as int, row['series_id'] as int);

  final InsertionAdapter<CategorySeries> _categorySeriesInsertionAdapter;

  final UpdateAdapter<CategorySeries> _categorySeriesUpdateAdapter;

  @override
  Future<List<CategorySeries>> findAllCategorySeries() async {
    return _queryAdapter.queryList('Select * from CategorySeries',
        mapper: _categoryseriesMapper);
  }

  @override
  Future<CategorySeries> getCategorySeriesById(int id) async {
    return _queryAdapter.query('Select * from CategorySeries where id = ?',
        arguments: <dynamic>[id], mapper: _categoryseriesMapper);
  }

  @override
  Future<List<CategorySeries>> getCategoryFromSeriesId(int seriesId) async {
    return _queryAdapter.queryList(
        'Select * from CategorySeries where series_Id = ?',
        arguments: <dynamic>[seriesId],
        mapper: _categoryseriesMapper);
  }

  @override
  Future<List<CategorySeries>> getSeriesFromCategoryId(int categoryId) async {
    return _queryAdapter.queryList(
        'Select * from CategorySeries where category_Id = ?',
        arguments: <dynamic>[categoryId],
        mapper: _categoryseriesMapper);
  }

  @override
  Future<void> deleteCategorySeries(int id) async {
    await _queryAdapter.queryNoReturn('Delete from CategorySeries where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> deleteAllCategorySeries() async {
    await _queryAdapter.queryNoReturn('Delete from CategorySeries');
  }

  @override
  Future<int> insertCategorySeries(CategorySeries categorySeries) {
    return _categorySeriesInsertionAdapter.insertAndReturnId(
        categorySeries, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategorySeries(CategorySeries categorySeries) async {
    await _categorySeriesUpdateAdapter.update(
        categorySeries, OnConflictStrategy.abort);
  }
}

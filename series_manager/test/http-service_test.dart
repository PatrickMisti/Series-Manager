import 'dart:typed_data';

import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/SerienManager.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:test/test.dart';

void main() {
  group('Test db', () {
    var urlPic =
        "https://serienstream.sx/public/img/cover/fairy-tail-stream-cover-uMVyjPu92Y0yioJMyTe0Y4P4WAm28x64_220x330.jpg";
    setUp(() async {
      await DataBaseExtension.init();
    });
    tearDown(() async {
      await DataBaseExtension.dispose();
    });
    test('db is not null', () async {
      Category category = new Category(null, "Action");
      await DataBaseExtension.insert(category);
      List<Category> c = await DataBaseExtension.getAll<Category>();
      Category cs = c.first;
      Future.delayed(Duration(seconds: 1));
      expect("Action", cs.categoryEnum);
      print(cs.categoryEnum);
    });
    test('test photo in db UInt8list', () async {
      var pic = await networkImageToByte(urlPic);
      Series s = new Series(null, "Fairy tail", "https://", pic, 1, 1,0);
      await DataBaseExtension.insert(s);
      Future.delayed(Duration(seconds: 1));
      List<Series> list = await DataBaseExtension.getAll<Series>();
      Series series = list.first;
      expect(1, list.length);
      expect("https://", series.video);
      expect(pic, series.seriePhoto);
      print(series.name);
    });
  });


  group('test db without extension', () {
    var db;
    setUp(() async {
      db = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    test('test db', () async {
      Category c = new Category(null, "Action");
      int i = await db.categoryDao.insertCategory(c);
      List<Category> s = await db.categoryDao.findAllCategories();
      Future.delayed(Duration(seconds: 1));
      //expect(!null, s);
      print("insert " + i.toString());
      expect(1, i);
      expect(1, s.length);
      var x = s.first;
      expect("Action", x.categoryEnum);
      print(x.id.toString() + " : " + x.categoryEnum);
    });

    test('test list ', () {
      var s = [
        {"t": 1, "y": "Hallo"},
        {"t": 2, "y": "ollah"}
      ];
      List<Category> c =
          List.of(s.map((e) => new Category(e["t"], e["y"].toString())));
      expect(2, c.length);
      c.forEach((element) => print(
          "Id: ${element.id.toString()}\nCategory: ${element.categoryEnum}"));

      c.forEach((element) => element.id = 10);
      c.forEach((element) => print(
          "Id: ${element.id.toString()}\nCategory: ${element.categoryEnum}"));
    });
  });
  group('find two times the same id', () {
    String url =
        'https://serienstream.sx/serie/stream/the-walking-dead';
    setUp(() async {
      //await DataBaseExtension.deleteDB();
      await DataBaseExtension.init();
    });

    test('db', () async {
      HttpService sv = new HttpService();
      //bool i = await sv.getDataSaveInDb(url);
      //expect(true, i);

      List<Category> category = await DataBaseExtension.getAll<Category>();
      category.forEach((element) => print("ListCategory: ${element.categoryEnum} \n"));
      expect(1, category.length);

      List<Series> series = await DataBaseExtension.getAll<Series>();
      series.forEach((element) => print("Series: ${element.name} \n"));
      expect(1, series.length);

      Category c = category.first;
      print("Category length c first: ${c.categoryEnum} \n\n");

      List<Series> seriesByCategoryId = await DataBaseExtension.getSeriesFromCategoryId(c.id);
      Future.delayed(Duration(seconds: 5));
      print("SeriesByCategoryId: ${seriesByCategoryId.length.toString()}\nSecond try");
      expect(1, seriesByCategoryId.length);

      seriesByCategoryId = await DataBaseExtension.getSeriesFromCategoryId(c.id);
      expect(1, seriesByCategoryId.length);
    });
  });
  group('Get all Links',() {
    test('all links from serienstream',() async {
      String url = 'https://serienstream.sx/serie/stream/the-walking-dead';
      SerienManager manager = new SerienManager(
          new Series(null,"hallo","akdslf",new Uint8List(9383848),1,1,0));
      //await manager.getEpisodeAndSeasonFromUrl(url);
      Future.delayed(Duration(seconds: 2));
      List<Map> all = manager.currentMovieList;
      List<Map> series = manager.currentSeriesList;
      print(all.length);
      print(series.length);

      expect(1, all.length);
      expect(10,series.length);
    });
  });

  group('hostersite', (){
    SerienManager manager;
    String url = 'https://serienstream.sx/serie/stream/the-walking-dead';

    setUp(() async{
      print("setup");
      manager = new SerienManager(
          new Series(null,"Servus","https://serienstream.sx/",new Uint8List(9383848),0,0,null));
      //await manager.getEpisodeAndSeasonFromUrl(url);
      Future.delayed(Duration(seconds: 2));
    });

    test('links from hoster from last watching',() async {

      var current = manager.currentEpisodeFromSeason();
      print(current);
      //expect('/serie/stream/the-walking-dead/filme/film-1',current["link"].toString());
    });

    test('links', () async{

      print("links");
      //todo url + current
      var current = manager.currentEpisodeFromSeason();
      var links = await manager.getHosterFromUrl(current["link"].toString());
      Future.delayed(Duration(seconds: 2));
      expect(11, links.length);
    });

  });

  group("fill Serienmanager", (){
    String url = 'https://serienstream.sx/serie/stream/the-walking-dead';

    test("test manager", () async {
      await DataBaseExtension.init();
      await HttpService.getDataSaveInDb(url);
      Future.delayed(Duration(seconds: 1));
      var series = await DataBaseExtension.getAll<Series>();
      Future.delayed(Duration(seconds: 1));
      expect(1, series.length);
      var firstOne = series.first;
      SerienManager manager = new SerienManager(firstOne);
      await manager.fillingManager();
      Future.delayed(Duration(seconds: 1));
      var current = manager.currentEpisodeFromSeason();
      print("Current from manager " + current.toString());
      var links = await manager.getHosterFromUrl();
      expect(11, links.length);
    });

  });
  tearDownAll(() async {
    await DataBaseExtension.dispose();
  });
}

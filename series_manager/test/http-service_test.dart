import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:test/test.dart';

void main(){
  group('Test db', () {
    var urlPic = "https://serienstream.sx/public/img/cover/fairy-tail-stream-cover-uMVyjPu92Y0yioJMyTe0Y4P4WAm28x64_220x330.jpg";
    setUp(() async{
      await DataBaseExtension.init();
    });
    tearDown(() async{
      await DataBaseExtension.dispose();
    });
    test('db is not null', () async{
      Category category = new Category(null,"Action");
      await DataBaseExtension.insert(category);
      List<Category> c = await DataBaseExtension.getAll<Category>();
      Category cs = c.first;
      Future.delayed(Duration(seconds: 1));
      expect("Action", cs.categoryEnum);
      print(cs.categoryEnum);
    });
    test('test photo in db UInt8list', () async{
      var pic = await networkImageToByte(urlPic);
      Series s = new Series(null, "Fairy tail", "https://", pic, 1, 1);
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

    test('test without await', (){
      Category c = new Category(null, "Action");
      int i = db.categoryDao.insertCategory(c);
      Category d = db;
    });
    test('test db', () async {
      Category c = new Category(null, "Action");
      int i = await db.categoryDao.insertCategory(c);
      List<Category> s = await db.categoryDao.findAllCategories();
      //Future.delayed(Duration(seconds: 1));
      //expect(!null, s);
      print("insert "+i.toString());
      expect(1, i);
      expect(1, s.length);
      var x = s.first;
      expect("Action", x.categoryEnum);
      print(x.id.toString() + " : " + x.categoryEnum);
    });

    test('test list ', () {
      var s = [
        {
          "t": 1,
          "y": "Hallo"
        },
        {
          "t": 2,
          "y": "ollah"
        }
      ];
      List<Category> c = List.of(s.map((e) => new Category(e["t"], e["y"].toString())));
      expect(2, c.length);
      c.forEach((element) => print("Id: ${element.id.toString()}\nCategory: ${element.categoryEnum}"));

      c.forEach((element) => element.id = 10);
      c.forEach((element) => print("Id: ${element.id.toString()}\nCategory: ${element.categoryEnum}"));
    });

  });
}
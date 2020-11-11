import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
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
}
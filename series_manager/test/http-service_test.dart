import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:test/test.dart';

void main() {
  group("Test http-service", () {
    setUp(() async {
      await DataBaseExtension.init();
    });
    test("Test getDataSaveInDb", () async {
      var start = await DataBaseExtension.getAll<Series>();
      expectLater(start.length, 0, reason: "start is not empty");

      bool before = await HttpService.getDataSaveInDb("https://serienstream.sx/serie/stream/lupin");
      start = await DataBaseExtension.getAll<Series>();
      expectLater(start.length, 1, reason: "start is not on 1");

      bool after = await HttpService.getDataSaveInDb("https://serienstream.sx/serie/stream/lupin");
      start = await DataBaseExtension.getAll<Series>();
      expectLater(start.length, 1, reason: "start should be 1");
      expectLater(before, !after, reason: "should be different");

      bool other = await HttpService.getDataSaveInDb("https://serienstream.sx/serie/stream/the-walking-dead");
      start = await DataBaseExtension.getAll<Series>();
      expectLater(start.length, 2, reason: "start should be 2");
      expectLater(before, other, reason: "should not be different");
    });
  });

}
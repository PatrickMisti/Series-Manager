import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:series_manager/main.dart';
import 'package:test/test.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';

void main(){
  DataBaseExtension db;
  setUp((){
    //runApp(Home());
  });
  group('Test db', () {
    var site = 'https://serienstream.sx/serie/stream/the-walking-dead/';
    test('add site to db', () async{
      HttpService service;
      var i = await service.getEpisodeAndSeasonFromUrl(site);
      Future.delayed(const Duration(seconds: 1));
      expectLater(!null, i);
    });
  });
}
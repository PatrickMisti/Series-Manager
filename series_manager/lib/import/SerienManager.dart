import 'dart:collection';
import 'package:html/parser.dart';

import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';

class SerienManager {
  List<Map> _season;
  final Series _series;

  SerienManager(this._series){
    this._season = new List<Map>();
  }

  Future<List<Map>> getEpisodeAndSeasonFromUrl(String url) async =>
      await _htmlGetEpisodeAndSeason(await _httpResponseConvert(url, 0), url);

  currentSeasonAndEpisodeList() => this._season;

  currentEpisodeFromSeason() {
    if (_series.episode != 0 && _series.season != 0)
      return this._season[_series.season]["episode"][_series.episode];
    if (_series.movie != 0)
      return null; //todo ["Movie"]
    else
      return this._season[0]["episode"][0];
  }

  Future<List<Map>> getHosterFromUrl(String url) async {
    var html = parse(await HttpService.httpClient(url));
    var hosterRaw = html.getElementsByClassName('hosterSiteVideo');
    //var languageRaw = hosterRaw[0].getElementsByClassName('changeLanguage'); // todo
    var hosterResult = hosterRaw[0].getElementsByClassName('row')[0].getElementsByTagName('a');
    var result = hosterResult.map((element) {
      return ({
        "hosttitle": element.getElementsByTagName('h4')[0].nodes[0].text.toString(),
        "hostlink": element.attributes['href'].toString()
      });
    }).toList();
    return result;
  }

  Future<List<LinkedHashMap<dynamic, String>>> _httpResponseConvert(
      uri, int index) async {
    var response = await HttpService.httpClient(uri);
    var html = parse(response);
    var body = html.getElementById('stream');
    var links = body.getElementsByTagName('ul');
    var item = links[index]
        .getElementsByTagName('a')
        .map((element) => element.attributes)
        .toList();
    item.forEach(
            (element) => element.removeWhere((key, value) => key == "class"));
    return item;
  }

  Future _htmlGetEpisodeAndSeason(
      List<LinkedHashMap<dynamic, String>> result, uri) async {
    List episodeAndSeason = new List<Map>();
    for (var item in result) {
      var element = await _httpResponseConvert(
          uri +'/'+ item["href"].toString().split('/').last, 1);
      List<Map> resultEpisode = new List<Map>();
      for (var episode in element) {
        Map map = ({
          "episode": episode["title"].toString(),
          "link": episode["href"].toString()
        });
        resultEpisode.add(map);
      }
      var resultRaw =
      Map.of({"season": item["title"], "episode": resultEpisode});
      episodeAndSeason.add(resultRaw);
    }
    this._season = episodeAndSeason;
  }
}
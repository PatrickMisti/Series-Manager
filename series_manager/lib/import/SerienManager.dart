import 'dart:collection';
import 'package:html/parser.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';

class SerienManager {
  List<Map> _managerSeriesList;
  List<Map> _managerMovieList;
  final Series _series;
  String originalUrl; //todo urUrl + path for links

  SerienManager(this._series){
    this._managerSeriesList = new List<Map>();
    this._managerMovieList = new List<Map>();
  }

  Future<List<Map>> getEpisodeAndSeasonFromUrl([String url]) async {
    var currentUrl = url == null ? _series.video : url;
    await _htmlGetEpisodeAndSeason(await _httpResponseConvert(currentUrl, 0), currentUrl);
  }


  List<Map> get currentSeriesList => this._managerSeriesList;

  List<Map> get currentMovieList => this._managerMovieList;

  Map currentEpisodeFromSeason() {
    if (_series.episode != null && _series.season != null)
      return this._managerSeriesList[_series.season]["episode"][_series.episode];
    if (_series.movie != null)
      return this._managerMovieList[0]["episode"][_series.movie];
    else
      return this._managerSeriesList[0]["episode"][0];
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
          "episodeName": episode["title"].toString(),
          "link": episode["href"].toString()
        });
        resultEpisode.add(map);
      }
      var resultRaw =
      Map.of({"series": item["title"], "episode": resultEpisode});
      episodeAndSeason.add(resultRaw);
    }
    setLists(episodeAndSeason);
  }

  void setLists(List<Map> episodeAndSeason){
    episodeAndSeason.forEach((element) {
      element["series"].compareTo("Alle Filme") == 0
      ? this._managerMovieList.add(element)
      : this._managerSeriesList.add(element);
    });
  }
}
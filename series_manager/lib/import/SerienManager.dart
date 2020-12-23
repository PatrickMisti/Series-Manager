import 'dart:collection';
import 'package:html/parser.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';

class SerienManager {
  List<Map> _managerSeriesList;
  List<Map> _managerMovieList;
  Series _series;
  String _originalUrl;

  SerienManager(this._series){
    this._managerSeriesList = new List<Map>();
    this._managerMovieList = new List<Map>();
    var oriUrlRaw = this._series.video.split('/');
    this._originalUrl = oriUrlRaw[0] + "//" + oriUrlRaw[2];
  }

  Future fillingManager() async {
    await _getEpisodeAndSeasonFromUrl();
  }

  Map getSerienManagerStats(){
    return {
      "season" : this._series.season,
      "episode"  : this._series.episode,
      "movie" : this._series.movie
    };
  }

  setCurrentManager(Map selectedFile , String option) {
    if(_managerMovieList.isNotEmpty && option.compareTo("Filme") == 0){
      List movieList = _managerMovieList[0]["episode"];
      var item = movieList.firstWhere((element) => element["id"] == selectedFile["id"], orElse: () => null);
      if(item != null){
        int movieIndex = movieList.indexOf(item);
        this._series.season = null;
        this._series.episode = null;
        this._series.movie = movieIndex;
      }
    }
    else {
      for(Map element in _managerSeriesList) {
        List<Map> items = element["episode"];
        var item = items.firstWhere((p) => p == selectedFile,orElse: () => null);

        if(item != null){
          int episodeIndex = items.indexOf(item);
          int seasonIndex = _managerSeriesList.indexOf(element);
          this._series.season = seasonIndex;
          this._series.episode = episodeIndex;
          this._series.movie = null;
          break;
        }
      }
    }
  }

  Future _getEpisodeAndSeasonFromUrl([String url]) async {
    var currentUrl = url == null ? _series.video : url;
    await _htmlGetEpisodeAndSeason(await _httpResponseConvert(currentUrl, 0), currentUrl);
  }

  List<Map> get currentSeriesList => this._managerSeriesList;

  List<Map> get currentMovieList => this._managerMovieList;

  Series get currentSeriesManager => this._series;

  List buttonListManager(){
    List result = new List();
    if(_managerMovieList.isNotEmpty)
      result.add(_managerMovieList);
    if(_managerSeriesList.isNotEmpty)
      result.add(_managerSeriesList);

    return result;
  }

  Map currentEpisodeFromSeason() {
    if ( _series.episode != null && _series.season != null)
      return this._managerSeriesList[_series.season]["episode"][_series.episode];
    if (_series.movie != null)
      return this._managerMovieList[0]["episode"][_series.movie];
    else
      return this._managerSeriesList[0]["episode"][0];
  }

  Future<List<Map>> getHosterFromUrl([String url]) async {
    url = url ?? currentEpisodeFromSeason()["link"].toString();
    var html = parse(await HttpService.httpClient(_originalUrl + url));
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
    int seasonCount = 0;
    for (var item in result) {
      var element = await _httpResponseConvert(
          uri +'/'+ item["href"].toString().split('/').last, 1);
      List<Map> resultEpisode = new List<Map>();
      int episodeCount = 0;
      for (var episode in element) {

        Map map = ({
          "id": seasonCount.toString() + "-"+ episodeCount.toString(),
          "episodeName": episode["title"].toString(),
          "link": episode["href"].toString()
        });
        resultEpisode.add(map);
        episodeCount++;
      }
      var resultRaw =
      Map.of({"series": item["title"], "episode": resultEpisode});
      episodeAndSeason.add(resultRaw);
      seasonCount++;
    }
    _setLists(episodeAndSeason);
  }

  void _setLists(List<Map> episodeAndSeason){
    episodeAndSeason.forEach((element) {
      element["series"].compareTo("Alle Filme") == 0
      ? this._managerMovieList.add(element)
      : this._managerSeriesList.add(element);
    });
  }
}
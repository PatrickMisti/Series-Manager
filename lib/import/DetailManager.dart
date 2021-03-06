import 'package:html/parser.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/manager.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:xml_parser/xml_parser.dart';


class DetailManager {
  final Series _series;
  List<ManagerSeason> _manager = <ManagerSeason>[];

  Series get getSeries => _series;

  List<ManagerSeason> get currentMovieList => _getCurrentList(selector: true);

  List<ManagerSeason> get currentSeasonList => _getCurrentList();

  _getCurrentList({bool selector = false}) {
    List<ManagerSeason> result = <ManagerSeason>[];
    _manager.forEach((element) {
      if(selector){
        if(element.seasonName == "Movie"){
          result.add(element);
        }
      }
      else {
        if (element.seasonName != "Movie") {
          result.add(element);
        }
      }
    });
    return result;
  }

  DetailManager(this._series);
  
  setCurrentEpisode(ManagerSerie selected) async {
    for (ManagerSeason items in _manager) {
      if (items.serieList.contains(selected)) {
        if (items.seasonName == "Movie") {
          _series.setEpisode(items.serieList.indexOf(selected) + 1, 0, 0);
        }
        else {
          _series.setEpisode(0, int.parse(items.seasonName), items.serieList.indexOf(selected) + 1);
        }
        break;
      }
    }
    await DataBaseExtension.update<Series>(_series);
  }

  String getCurrentEpisodeUrl() {
    ManagerSerie element = this.getCurrentEpisode();
    return element.serieLink;
  }
  
  ManagerSerie getCurrentEpisode() {
    if(_series.movie != 0) {
      ManagerSeason list = _manager.where((element) => element.seasonName == "Movie").first;
      return list.serieList[_series.movie - 1];
    }
    else {
      ManagerSeason list = _manager.where((element) => int.tryParse(element.seasonName) == _series.season).first;
      return list.serieList[_series.episode - 1];
    }
  }

  startFillingList() async {
    var seasons = await _getSeasonOrEpisodeFromLink(_series.video);
    for (var item in seasons) {
      String seasonLink = _series.video + "/${item
          .getAttribute("href")
          .split('/')
          .last}";
      var titleName = int.tryParse(item.children[0].value) ?? "Movie";
      ManagerSeason resultSeason = new ManagerSeason(
          titleName.toString());
      var serie = await _getSeasonOrEpisodeFromLink(seasonLink, choose: 1);
      for (var element in serie) {
        String episodeLink = seasonLink + "/${element
            .getAttribute("href")
            .split("/")
            .last}";
        ManagerSerie resultSerie = new ManagerSerie(
            element.getAttribute("data-episode-id"),
            element.getAttribute("title"), episodeLink);
        resultSeason.serieList.add(resultSerie);
      }
      _manager.add(resultSeason);
    }
    _manager.toList(growable: false);
  }

  _getSeasonOrEpisodeFromLink(String url, {int choose = 0}) async {
    var seasonListRaw = parse(await HttpService.httpClient(url))
        .getElementById('stream')
        .getElementsByTagName('ul');
    var xml = XmlDocument.fromString(seasonListRaw[choose].outerHtml);
    return xml.getElements('a');
  }

  Future<List<HosterLanguageManager>> getHosterAndLanguageForSeries(String url) async {
    List<HosterLanguageManager> langManager = <HosterLanguageManager>[];
    var html = parse(await HttpService.httpClient(url)).getElementsByClassName('hosterSiteVideo')[0];
    var language = XmlDocument.fromString(html.getElementsByClassName("changeLanguageBox")[0].innerHtml);

    List<HosterManager> hoster = await _getHosterForSeries(html);

    language.children.skip(1).forEach((element) {
      int startTitle = element.toString().indexOf("title=");
      int endTitle = element.toString().indexOf("\"", startTitle + 7);
      String resultTitle = element.toString()
          .substring(startTitle, endTitle)
          .split("\"")[1];

      int startLangKey = element.toString().indexOf("lang-key=\"");
      int endLangKey = element.toString().indexOf("\"", startLangKey + 10);
      int resultLangKey = int.parse(
          element
              .toString().substring(startLangKey, endLangKey)
              .split("\"")[1]);

      langManager.add(new HosterLanguageManager(resultLangKey, resultTitle));
    });

    langManager.forEach((element) {
      hoster.forEach((item) {
        if (element.id == item.languageId)
          element.hosterManagerList.add(item);
      });
    });

    return langManager;
  }

  Future<List<HosterManager>> _getHosterForSeries(html) async {
    List<XmlNode> hoster = XmlDocument
        .fromString(html.getElementsByClassName('row')[0].innerHtml)
        .children;
    List<HosterManager> hosterManager = <HosterManager>[];
    for (XmlElement element in hoster) {
      hosterManager.add(
          new HosterManager(
              int.parse(element.getAttribute('data-lang-key')),
              element.getAttribute('data-link-target'),
              element
                  .getElement('h4')
                  .text));
    }
    return hosterManager;
  }
}

extension ConvertListOfManagerSeason on List<ManagerSeason> {
  List<ManagerSerie> convertToManagerSerieList() {
    List<ManagerSerie> result = <ManagerSerie>[];
    this.forEach((element) => result.addAll(element.serieList));
    return result;
  }
}
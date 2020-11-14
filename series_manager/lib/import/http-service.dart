import 'dart:collection';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

class HttpService {
  Future<String> _httpClient(uri) async => await http
      .get(Uri.parse(uri), headers: {
        "Content-type": "application/xml",
        "Accept": "application/xml"
      })
      .then((value) => value.body)
      .then((value) => value.replaceAll("\r\n", '').replaceAll("\n", ''));

  Future<List<Map>> getEpisodeAndSeasonFromUrl(String url) async =>
      await _htmlGetEpisodeAndSeason(await _httpResponseConvert(url, 0), url);

  Future<bool> getDataSaveInDb(String url) async {
    List<Series> allSeries = await DataBaseExtension.getAll<Series>();
    bool exist = false;
    allSeries.forEach((element) {
      if (element.video.compareTo(url) == 0 && exist == false) {
        exist = true;
      }
    });
    if (!exist) {
      var result = await _httpClient(url);
      var header = await _htmlGetImageAndTitle(result, url);
      List<Category> category = await _htmlGetCategoryFromSeries(result);
      var series = Series.fetching(
          name: header["title"],
          seriePhoto: header["image"],
          episode: 1,
          season: 1,
          video: url);
      int episodeId = await DataBaseExtension.insert<Series>(series);
      await DataBaseExtension.saveCategoriesToSeries(episodeId,category);
    }
    return exist;
  }

  Future<List<Category>> _htmlGetCategoryFromSeries(String result) async {
    var html = parse(result);
    var genre = html.querySelector('div.genres').getElementsByTagName('a');

    List<Category> categories = List.of(genre.map((e) => new Category(null, e.nodes[0].text)));
    List<Category> savedCategories = await DataBaseExtension.getAll<Category>();

    if (savedCategories.length > 0 && savedCategories != null)
      categories.forEach((element) async {
        var hope = savedCategories
            .where((e) =>
        e.categoryEnum.toLowerCase().compareTo(element.categoryEnum.toLowerCase()) == 0);
        if(hope.isEmpty){
          await DataBaseExtension.insert(element).then((value) => element.id = value);
        } else {
          Category categoryDb = hope.first;
          element.id = categoryDb.id;
        }
      });
    else
      categories.forEach((element) async{
        await DataBaseExtension.insert<Category>(element).then((value) => element.id = value);
      });

    return categories;
  }

  Future<Map> _htmlGetImageAndTitle(String response, String uri) async {
    var html = parse(response);
    var title = html
        .querySelector("h1[title]")
        .nodes[0]
        .nodes[0]
        .text; // titel von der Serie
    var imageUri = html
        .querySelector("div.seriesCoverBox")
        .nodes[0]
        .attributes["data-src"]; //https://serienstream.sx/+ imageurl
    var basicUri = uri.split('/');
    var fullImageUri = basicUri[0].toString() +
        "//" +
        basicUri[2].toString() +
        imageUri.toString();
    var image = await networkImageToByte(fullImageUri);

    return ({"title": title.toString(), "image": image});
  }

  Future<List<LinkedHashMap<dynamic, String>>> _httpResponseConvert(
      uri, int index) async {
    var response = await _httpClient(uri);
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

  Future<List<Map>> _htmlGetEpisodeAndSeason(
      List<LinkedHashMap<dynamic, String>> result, uri) async {
    List episodeAndSeason = new List<Map>();
    for (var item in result) {
      var element = await _httpResponseConvert(
          uri + item["href"].toString().split('/').last, 1);
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
    return episodeAndSeason;
  }
}

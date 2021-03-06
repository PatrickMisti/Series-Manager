import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/data/entities/serie.dart';

class HttpService {
  static Future<String> httpClient(uri) async => await http
      .get(Uri.parse(uri), headers: {
        "Content-type": "application/xml",
        "Accept": "application/xml"
      })
      .then((value) => value.body)
      .then((value) => value.replaceAll("\r\n", '').replaceAll("\n", ''));


  static Future<bool> getDataSaveInDb(String url) async {
    List<Series> compareSeries = await DataBaseExtension.getComparedOfSeriesUrl(url);

    if (compareSeries.isEmpty) {
      var result = await HttpService.httpClient(url);
      var header = await _htmlGetImageAndTitle(result, url);
      List<Category> category = await _htmlGetCategoryFromSeries(result);
      var series = Series.fetching(
          name: header["title"],
          seriePhoto: header["image"],
          episode: 1,
          season: 1,
          movie: 0,
          video: url);
      int episodeId = await DataBaseExtension.insert<Series>(series);
      await DataBaseExtension.saveCategoriesToSeries(episodeId,category);
    }
    return compareSeries.isEmpty ? true : false;
  }

  static Future<List<Category>> _htmlGetCategoryFromSeries(String result) async {
    var html = parse(result);
    var genre = html.querySelector('div.genres').getElementsByTagName('a');

    List<Category> categories = List.of(genre.map((e) => new Category(null, e.nodes[0].text)));
    List<Category> savedCategories = await DataBaseExtension.getAll<Category>();

    if (savedCategories.length > 0 && savedCategories != null)
      categories.forEach((element) async {
        var hope = savedCategories
            .where((e) =>
        e.categoryName.toLowerCase().compareTo(element.categoryName.toLowerCase()) == 0);
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

  static Future<Map> _htmlGetImageAndTitle(String response, String uri) async {
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
}

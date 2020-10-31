import 'dart:collection';
import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HttpService{

  String url = 'https://serienstream.sx/serie/stream/black-clover/';

  Future getDataFromInternet() async{
    var result = await _httpResponse(url,0);
    
    List episodeAndSeason = new List<Map>();
    for(var item in result) {
      var element = await _getEpisodeFromSeason(item["href"].toString());
      List<Map> resultEpisode = new List<Map>();
      for(var episode in element) {
        Map map = ({
          "episode": episode["title"].toString(),
          "link": episode["href"].toString()
        });
        resultEpisode.add(map);
      }
      var resultRaw = Map.of({"season": item["title"], "episode": resultEpisode});
      episodeAndSeason.add(resultRaw);
    }
    return episodeAndSeason;
  }

  Future<List<LinkedHashMap<dynamic,String>>> _httpResponse(url,int index) async {
    var response = await http.get(Uri.parse(url),headers: {"Content-type": "application/xml", "Accept": "application/xml"})
        .then((value) => value.body)
        .then((value) => value.replaceAll("\r\n", '').replaceAll("\n", ''));
    var html = parse(response);
    var title = html.querySelector("h1[title]").nodes[0].nodes[0].text; // titel von der Serie
    var image = html.querySelector("div.seriesCoverBox").nodes[0].attributes["data-src"]; //https://serienstream.sx/+ imageurl
    var body = html.getElementById('stream');
    var links = body.getElementsByTagName('ul');
    var item = links[index]
        .getElementsByTagName('a')
        .map((element) => element.attributes).toList();
    item.forEach((element)=> element.removeWhere((key, value) => key == "class"));
    return item;
  }

  Future<List<LinkedHashMap<dynamic,String>>> _getEpisodeFromSeason(String item) async {
    var response = await _httpResponse(url + item.split('/').last,1);
    return response;
  }
}
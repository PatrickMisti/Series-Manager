class ManagerSeason {
  final String seasonName;
  List<ManagerSerie> serieList = <ManagerSerie>[];

  ManagerSeason(this.seasonName);

  addListToSeason(List<ManagerSerie> list) => serieList = list;
}

class ManagerSerie {
  final String serieName;
  final String serieLink;
  final String episodeId;

  ManagerSerie(this.episodeId, this.serieName, this.serieLink);
}

class HosterLanguageManager {
  final String language;
  final int id;
  List<HosterManager> hosterManagerList = <HosterManager>[];

  HosterLanguageManager(this.id, this.language);
}

class HosterManager {
  final int languageId;
  final String browserurl;
  final String name;

  HosterManager(this.languageId, this.browserurl, this.name);
}
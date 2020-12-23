import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/import/SerienManager.dart';
import 'package:series_manager/main.dart';

class Detail extends StatefulWidget {
  final SerienManager manager;

  const Detail({Key key, this.manager}) : super(key: key);

  @override
  _Detail createState() => _Detail(manager: manager);
}

class _Detail extends State<Detail> {
  Size size;
  final SerienManager manager;

  _Detail({this.manager});

  GestureDetector showHostLink(Map hostLinks) {
    return GestureDetector(
      onTap: () => {
        //todo url setup
      },
      child: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  hostLinks["hosttitle"].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.play_arrow_outlined,
                    size: 30, color: Colors.white),
                onPressed: null,
              ),
            ),
          ],
        ),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(
                color: primaryColor, width: 4, style: BorderStyle.solid)),
      ),
    );
  }
  
  initPicker(List season,String option) {
    var stats = this.manager.getSerienManagerStats();
    if(option.compareTo("Filme") == 0 && stats["movie"] == null)
      return 0;
    if(option.compareTo("Serien") == 0 && stats["episode"] == null && stats["season"] == null)
      return 0;
    else
      return season.indexOf(this.manager.currentEpisodeFromSeason());
  }

  showCupertinoSeriesAndSeasonPicker(List<Map> seasonOrEpisode, String option) {
    List<Map> season = new List<Map>();
    seasonOrEpisode.forEach((element) => season.addAll(element["episode"]));
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          //todo season click than movie click movielist is long as seasonlist
      return new Container(
          height: size.height * 0.3,
          child: new CupertinoPicker(
              scrollController: FixedExtentScrollController(
                  initialItem: initPicker(season,option)
              ),
            itemExtent: 30,
            onSelectedItemChanged: (value) {
              setState(() {
                print(value);
                manager.setCurrentManager(season[value], option);
              });
            },
            children: new List<Widget>.generate(season.length, (index) => Text(season[index]["episodeName"]))
          ),
      );
    });
  }

  Row showButtonStyle() {
    return Row(
      children: [
        if (manager.currentMovieList.isNotEmpty)
          Expanded(
              child: CupertinoButton(
                onPressed: () =>
                {
                  setState((){
                    showCupertinoSeriesAndSeasonPicker(manager.currentMovieList, "Filme");
                  })
                },
                child: Center(
                  child: Text(
                    'Filme',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                color: primaryColor,
                padding: EdgeInsets.all(10),
              )
          ),
        if (manager.currentSeriesList.isNotEmpty &&
            manager.currentMovieList.isNotEmpty)
          SizedBox(width: 10),
        if (manager.currentSeriesList.isNotEmpty)
          Expanded(
              child: CupertinoButton(
                onPressed: () =>
                {
                  setState(() {
                    showCupertinoSeriesAndSeasonPicker(manager.currentSeriesList, "Serien");
                  })
                },
                child: Center(
                  child: Text(
                    'Serien',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                color: primaryColor,
                padding: EdgeInsets.all(10),
              )
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: this.manager.fillingManager(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                backgroundColor: Colors.black,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    manager.currentSeriesManager.name,
                    style: TextStyle(color: primaryColor, fontSize: 20),
                  ),
                  background: Image.memory(
                    manager.currentSeriesManager.seriePhoto,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: size.width,
                      margin: EdgeInsets.only(top: 15),
                      child: showButtonStyle()),
                  FutureBuilder(
                      future: manager.getHosterFromUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: size.height,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return showHostLink(snapshot.data[index]);
                              },
                            ),
                          );
                        } else
                          return new CircularProgressIndicator(strokeWidth: 20,);
                      }),
                ]),
              ),
            ],
          );
        },
      )
    );
  }
}

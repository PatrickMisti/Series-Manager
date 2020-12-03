import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/main.dart';

class Detail extends StatefulWidget {
  @override
  _Detail createState() => _Detail();
}

class _Detail extends State<Detail> {
  Size size;
  Map selectedSeries;
  HttpService sv;
  var hostingFunction;

  @override
  void initState() {
    super.initState();
    sv = new HttpService();
  }

  List<Widget> generateListForPicker(List<Map> raw){
    List<Map> result = new List<Map>();
    raw.forEach((element) => result.addAll(element["episode"]));
    return List<Widget>.generate(result.length, 
            (index) => new Text(result[index]["episode"]));
  }

  showHostLink(Map hostLinks){
    return Container(
      child: Column(
        children: [
          Text(hostLinks["hosttitle"]),
          IconButton(
              icon: Icon(Icons.play_arrow_outlined),
              onPressed: null,
          )
        ],
      ),
    );
  }

  showCupertinoSeriesAndSeasonPicker(List<Map> seasonOrEpisode){
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: size.height * 0.3,
            child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (value){
                  setState(() {
                    selectedSeries = seasonOrEpisode[value];
                    hostingFunction = sv.getHosterFromUrl(selectedSeries['episode']);
                  });
                },
                children: generateListForPicker(seasonOrEpisode),
            ),
          );
        }
    );
  }
  
  CupertinoButton showButtonStyle(Series current, AsyncSnapshot dropDownList) {
    return CupertinoButton(
      onPressed: () => {
        if(dropDownList.hasData) {
          showCupertinoSeriesAndSeasonPicker(dropDownList.data)

        }
      },
      child: Container(
          width: size.width,
          height: 50,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          child: Center(
            child: Text(
              'Season ${current.season}   Episode ${current.episode}',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          )
      ),
    );
  }
  setSelectMap(Series open) async{
    List<Map> getSeasonAndEpisode = await sv.getEpisodeAndSeasonFromUrl(open.video);
    int count = open.season;
    if(getSeasonAndEpisode["season"].containsValue("Alle Filme")){
      count++;
    }
    selectedSeries = getSeasonAndEpisode[count][open.episode];
  }

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    final Series currentSeries = ModalRoute.of(context).settings.arguments;
    setSelectMap(currentSeries);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.black,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                currentSeries.name,
                style: TextStyle(color: primaryColor, fontSize: 20),
              ),
              background: Image.memory(
                currentSeries.seriePhoto,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(<Widget>[
              Column(
                children: [
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: 10),
                    child: FutureBuilder(
                      future: sv.getEpisodeAndSeasonFromUrl(currentSeries.video),
                      builder: (context, snapshot){
                        return showButtonStyle(currentSeries, snapshot);
                      },
                    )
                  ),
                  Container(
                    height: size.height,
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: hostingFunction,
                          builder: (content,snapshot){
                            if(snapshot.hasData){
                              return ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (BuildContext content, int position) {
                                    return showHostLink(snapshot.data[position]);
                                  });
                            }
                            else {
                              return Container(
                                child: Text("Data chosen"),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
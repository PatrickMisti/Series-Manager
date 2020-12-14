import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/SerienManager.dart';
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
                  });
                },
            ),
          );
        }
    );
  }
  
  CupertinoButton showButtonStyle() {
    return CupertinoButton(
      onPressed: () => {

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
              'Season',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    final SerienManager currentSeries = ModalRoute.of(context).settings.arguments;
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
                currentSeries.currentSeriesManager.name,
                style: TextStyle(color: primaryColor, fontSize: 20),
              ),
              background: Image.memory(
                currentSeries.currentSeriesManager.seriePhoto,
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
                    child: showButtonStyle()
                  ),
                  Container(
                    height: size.height,
                    child: Row(
                      children: [
                        //todo hostlinks
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
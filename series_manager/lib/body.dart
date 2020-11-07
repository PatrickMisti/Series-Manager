import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/database/service.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/main.dart';
import 'package:series_manager/views/BottomSheetSetLink.dart';
import 'package:series_manager/views/SeriesComponent.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  DataBaseExtension db;
  HttpService service;

  @override
  void initState() {
    super.initState();
    db = new DataBaseExtension();
    _insertDataToDb();
  }

  Future<void> _insertDataToDb() async {
    //var result = await db.getAll<Category>();
    await db.deleteAll<Category>();
    /*if(result.length == 0){
      var insertCategory = Service.getCategory();
      for(var item in insertCategory){
        await db.insert<Category>(item);
      }
    }*/
  }

  Container categoryListView(Category category, Size size) {
    var items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    return Container(
      height: size.height * 0.35,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            bottom: 5,
            child: Text(
              category.categoryEnum,
              style: GoogleFonts.alef(fontSize: 27, color: primaryColor),
            ),
          ),
          Positioned(
            top: 10,
            height: 250,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    height: 200,
                    width: size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FutureBuilder(
                      future: db.getAll<Series>(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, int position) {
                                  return SeriesComponent(
                                      category: null, size: null); //todo
                                })
                            : Center(
                                child: Text("No Data send Patrick mail"),
                              );
                      },
                    )
                )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
              Container(
                height: size.height - 50,
                child: FutureBuilder(
                  future: db.getAll<Category>(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, int position) {
                              return categoryListView(
                                  snapshot.data[position], size);
                            })
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
        BottomSheetSetLink(size),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/main.dart';
import 'package:series_manager/views/BottomSheetSetLink.dart';
import 'package:series_manager/views/SeriesComponent.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  DataBaseExtension db;

  @override
  void initState() {
    super.initState();
    db = new DataBaseExtension();
    _insertDataToDb();
  }

  Future<void> _insertDataToDb() async {
    await db.deleteAll<Category>();
  }

  Container categoryListView(Category category, Size size) {
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
                      future: db.getSeriesFromCategory(category.id),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, int position) {
                                  return SeriesComponent(
                                      series: snapshot.data[position],
                                      size: size);
                                })
                            : Center(
                                child: Text("No Data send Patrick mail"),
                              );
                      },
                    ))),
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
                    return snapshot.hasData && snapshot.data.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, int position) {
                              return categoryListView(
                                  snapshot.data[position], size);
                            })
                        : Container(
                            padding: EdgeInsets.only(top: size.height * 0.5),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "No Content please add some Links",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Icon(Icons.arrow_downward,
                                      color: Colors.white, size: 50),
                                ],
                              ),
                            ),
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

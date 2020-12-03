import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/main.dart';
import 'package:series_manager/views/AlertDialogForNotification.dart';
import 'package:series_manager/views/BottomSheetSetLink.dart';
import 'package:series_manager/views/SeriesComponent.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {

  @override
  void initState() {
    super.initState();
  }

  saveUrlToDatabase(String url) async {
    if (!await HttpService.getDataSaveInDb(url))
      setState((){});
    else
      AlertDialogForNotification.activeDialog = true;
  }

  Future<List<Series>> setSeriesListFromCatSerId(int categoryId) async {
    return await DataBaseExtension.getSeriesFromCategoryId(categoryId);
  }
  
  categoryListView(Category category, Size size) {
    var settings = setSeriesListFromCatSerId(category.id);
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
              child: FutureBuilder(
                  future: settings,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Series> series = snapshot.data;
                      return Container(
                        height: 200,
                        width: size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: SeriesComponent(
                            series: series, size: size),
                      );
                    } else {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  }),
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
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
              Container(
                height: size.height - 50,
                child: FutureBuilder(
                  future: DataBaseExtension.getAll<Category>(),
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
        BottomSheetSetLink(size,toSaveData: saveUrlToDatabase,),
      ],
    );
  }
}

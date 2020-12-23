import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/data/entities/serie.dart';
import 'package:series_manager/detail.dart';
import 'package:series_manager/import/SerienManager.dart';

class SeriesComponent extends StatelessWidget {
  SeriesComponent({@required this.series, @required this.size});

  final Size size;
  final List<Series> series;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: series.length,
        itemBuilder: (_, int position) {
          return GestureDetector(
            onTap: () async {
              SerienManager manager = new SerienManager(series[position]);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(manager: manager)));
            },
            child: Container(
              height: 200,
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(series[position].seriePhoto),
                    fit: BoxFit.fill),
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(series[position].name,
                        style:
                        GoogleFonts.alef(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        )
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

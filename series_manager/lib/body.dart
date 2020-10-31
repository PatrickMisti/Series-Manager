import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/database/service.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/main.dart';
import 'package:series_manager/views/SeriesComponent.dart';

class Body extends StatefulWidget{
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{

  List<Category> categories;
  DataBaseExtension db;
  HttpService service;

  @override
  void initState(){
    super.initState();
    db = new DataBaseExtension();
    _insertDataToDb();
    _getAllCategories();
  }

  Future<void> _insertDataToDb() async{
    service = new HttpService();
    //await service.getDataSaveInDb("https://serienstream.sx/serie/stream/black-clover/");
    var result = await db.getAll<Category>();
    //await db.deleteAll<Category>();
    if(result.length == 0){
      var insertCategory = Service.getCategory();
      for(var item in insertCategory){
        await db.insert<Category>(item);
      }
    }
  }

  Future<void>_getAllCategories() async {
    var result = await db.getAll<Category>();
    setState(() {
      categories = result;
    });
  }

  Container categoryListView(Category category,Size size){
    var items = [1,2,3,4,5,6,7,8,9,10];
    return Container(
      height: size.height *0.35,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            bottom: 5,
            child: Text(
              category.categoryEnum,
              style: GoogleFonts.alef(
                fontSize: 27,
                color: primaryColor
              ),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (_,int position){
                      return SeriesComponent(category: category, size: size);
                    }
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)  {
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
                height: size.height * 0.9,
                child: categories == null ? Container(child: Center(child: Text("No Elements"))):
                ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (_,int position){
                    return categoryListView(categories[position],size);
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom:-3,
          width: size.width,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width/2.3),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.rectangle,
              boxShadow: [BoxShadow(
                color: primaryColor,
                offset: Offset(0,30),
                spreadRadius: 4,

              )],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.elliptical(-80, 20)
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.add,color: Colors.black,),
              iconSize: 30,
              onPressed: null,
            ),
          ),
        ),
      ],
    );
  }
}
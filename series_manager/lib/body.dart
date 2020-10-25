import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:series_manager/data/database/appDatabase.dart';
import 'package:series_manager/data/database/service.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatefulWidget{
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{

  List<Category> categories;
  var dbCategory = $FloorAppDatabase.databaseBuilder('category').build();
  var dbSeries = $FloorAppDatabase.databaseBuilder('series').build();

  @override
  void initState(){
    super.initState();
    _insertDataToDb();
    _getAllCategories();
  }

  Future<void> _insertDataToDb() async{
    //await dbCategory.then((value) => value.categoryDao).then((value) => value.deleteAllCategories());
    var result = await dbCategory.then((value) => value.categoryDao.findAllCategories());
    if(result.length == 0){
      var insertCategory = Service.getCategory();
      for(var item in insertCategory){
        dbCategory.then((value) => value.categoryDao.insertCategory(item));
      }
    }
  }

  Future<void>_getAllCategories() async {
    var result = await dbCategory.then((value) => value.categoryDao.findAllCategories());
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
                fontSize: 27
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
    return SingleChildScrollView(
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
    );
  }
}

class SeriesComponent extends StatelessWidget{
  SeriesComponent({Key key,@required this.category,@required this.size}):super(key:key);

  final Size size;
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(20,20),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.25)
          )
        ]
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              category.id.toString(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderBoxWithSearch extends StatelessWidget{
  HeaderBoxWithSearch({Key key,@required this.size}):super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.1 - 30,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.symmetric(horizontal:15),
                height: 54,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,50),
                        blurRadius: 50,
                        color: Colors.black.withOpacity(0.50),
                      )
                    ]
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.blue.withOpacity(0.5)
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: null
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
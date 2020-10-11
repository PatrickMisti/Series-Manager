import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget{
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{
  final array = [1,2,3,4,5];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderBoxWithSearch(size: size),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0),
          ),
          SizedBox(
            height: size.height * 0.8,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: array.length,
                itemBuilder: (context,index) => SeriesComponent(id: array[index], size: size)
            ),
          ),
        ],
      ),
    );
  }
}

class SeriesComponent extends StatelessWidget{
  SeriesComponent({Key key,@required this.id,@required this.size}):super(key:key);

  final Size size;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.15,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,40),
            blurRadius: 50,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.15)
          )
        ]
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              id.toString(),
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
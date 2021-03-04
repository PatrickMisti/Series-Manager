import 'package:flutter/cupertino.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/data/entities/category.dart';
import 'package:series_manager/views/overview/SeriesView.dart';

class CategoryView extends StatelessWidget {

  //todo Stateful for feature
  /*viewActivityIndicatorOrText() async{
    var component = Center(child: CupertinoActivityIndicator(),);
    await Future.delayed(Duration(seconds: 15)).then((value) => setState((){
      component = Center(child: Text("No elements"))
    }));
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseExtension.getAll<Category>(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Category> categoryList = snapshot.data;
          return ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (_, index) {
                return Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            categoryList[index].categoryName,
                            style: TextStyle(color: CupertinoColors.white,
                              fontSize: 20
                            ),
                          )),
                      Flexible(child: SeriesView(categoryList[index].id))
                    ],
                  ),
                );
              }
          );
        }
        return CupertinoActivityIndicator();
      },
    );
  }
}
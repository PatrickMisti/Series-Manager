import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/DatabaseExtension/database-extension.dart';
import 'package:series_manager/views/search/SearchElementView.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  String input;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.teal,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        middle: CupertinoTextField(
          placeholder: "Input",
          placeholderStyle: TextStyle(color: Colors.tealAccent),
          onChanged: (value) {
            setState(() {
              input = value;
            });
          },
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.teal
          ),
        ),
      ),
      body: input != null
          ? FutureBuilder(
              future: DataBaseExtension.findSeriesByName(input),
              builder: (_, snapshot) {
                return snapshot.hasData ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) =>
                      SearchElementView(series: snapshot.data[index]),
                )
                : Center(child: CupertinoActivityIndicator());
              },
            )
          : Container(),
    );
  }
}

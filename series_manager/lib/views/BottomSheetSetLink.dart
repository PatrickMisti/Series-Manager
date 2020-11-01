import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_manager/main.dart';

class BottomSheetSetLink extends StatefulWidget {
  final Size size;

  BottomSheetSetLink({@required this.size});

  @override
  _BottomSheetSetLink createState() => _BottomSheetSetLink(size:size);
}
class _BottomSheetSetLink extends State<BottomSheetSetLink> {
  Size size;


  _BottomSheetSetLink({@required this.size});



  actionSheet(context){
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext content){
          return Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: size.height *0.1,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.white
                  ),
                  child: Text("halllo",style: TextStyle(color: primaryColor)),
                ),
              ),
              SizedBox(height: 10),
              FlatButton(
                height: 50,
                minWidth: size.width - 40,
                onPressed: () =>{
                  Navigator.pop(content)
                },
                color: Colors.white,
                child: Text("Speichern",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              SizedBox(height: 5,)
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
          onPressed: () => actionSheet(context)
        ),
      ),
    );
  }
}
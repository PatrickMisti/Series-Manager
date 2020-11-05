import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/main.dart';

class BottomSheetSetLink extends StatefulWidget {
  final Size size;

  BottomSheetSetLink({@required this.size});

  @override
  _BottomSheetSetLink createState() => _BottomSheetSetLink(size:size);
}
class _BottomSheetSetLink extends State<BottomSheetSetLink> {
  Size size;
  final _linkInput = TextEditingController();

  _BottomSheetSetLink({@required this.size});

  getLinkAndSave(){

  }

  showBottomSheetForm(){
    var bottomSheetKey = Key('container');
    return Container(
      key: bottomSheetKey,
        height: 20,
        padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 20),
        child: Column(
          children: [
            Text(
              "Bitte geben sie hier ihren Link ein!",
              style: GoogleFonts.alegreyaSc(
                  fontSize: 20.5
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30),
                child: TextField(
                  keyboardType: TextInputType.url,
                  controller: _linkInput,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Beispiel 'http://serienstream.sx/serie\n/stream/the-walking-dead/'",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                )
            ),
          ],
        ),
      );
  }

  actionSheet(context){
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext content){
          return Container(
            height: size.height*0.5, // size.height*0.46
            child: Column(
              children: [
                Container(
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white
                      ),
                      child: showBottomSheetForm(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  height: 50,
                  minWidth: size.width - 40,
                  onPressed: () =>{
                    getLinkAndSave(),
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
            ),
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
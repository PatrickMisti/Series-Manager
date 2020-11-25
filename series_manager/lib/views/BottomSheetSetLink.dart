import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/main.dart';
import 'package:series_manager/views/AlertDialogForNotification.dart';


class BottomSheetSetLink extends StatefulWidget {
  final Size size;
  final toSaveData;
  BottomSheetSetLink(this.size,{this.toSaveData});



  @override
  _BottomSheetSetLink createState() => _BottomSheetSetLink(this.size);
}

class _BottomSheetSetLink extends State<BottomSheetSetLink> with SingleTickerProviderStateMixin {
  final Size size;
  final _linkInput = TextEditingController();
  double _bottomViewSize = 0.45;
  FocusNode _focusOnTextField = FocusNode();
  var bottomSheetKey = Key('container');

  @override
  void initState() {
    super.initState();
    _focusOnTextField.addListener(() => _bottomViewSize = _focusOnTextField.hasFocus ? 0.85 : 0.45);
  }

  _BottomSheetSetLink(this.size);

  getLinkAndSave() async{
    if(_linkInput.text.isNotEmpty && _linkInput.text.length > 22 && _linkInput.text.split('/').length >= 6) {
      var createLink = _linkInput.text
          .split('/')
          .sublist(0,6)
          .join('/');
      log(createLink);
      widget.toSaveData(createLink);
    }
  }

  showBottomSheetForm(context) {
    return Container(
      key: bottomSheetKey,
      height: 20,
      padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
      child: Column(
        children: [
          Text(
            "Bitte geben sie hier ihren Link ein!",
            style: GoogleFonts.alegreyaSc(fontSize: 20.5),
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: TextField(
                  keyboardType: TextInputType.url,
                  controller: _linkInput,
                  maxLines: 5,
                  focusNode: _focusOnTextField,
                  decoration: const InputDecoration(
                    hintText:
                    "Beispiel 'http://serienstream.sx/serie\n/stream/the-walking-dead/'",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)))
          ),
          //todo maybe witch provider textfield
        ],
      ),
    );
  }

  actionSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        elevation: 5,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext content) {
          return Container(
            height: size.height * _bottomViewSize,
            width: size.width,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  height: size.height * 0.35,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white),
                    child: showBottomSheetForm(content),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 20,
                  right: 20,
                  child: FlatButton(
                    height: 50,
                    onPressed: () {
                      getLinkAndSave();
                      _linkInput.text = '';
                      Navigator.pop(content);
                      AlertDialogForNotification.showDialogAlert(content,AlertDialogForNotification.activeDialog);
                    },
                    color: Colors.white,
                    child: Text(
                      "Speichern",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -3,
      width: size.width,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width / 2.3),
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: primaryColor,
              offset: Offset(0, 30),
              spreadRadius: 4,
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.elliptical(-80, 20)),
        ),
        child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            iconSize: 30,
            onPressed: () => actionSheet(context)),
      ),
    );
  }
}

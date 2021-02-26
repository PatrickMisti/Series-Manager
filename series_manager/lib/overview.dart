import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/import/http-service.dart';
import 'package:series_manager/views/overview/CategoryView.dart';

class Overview extends StatefulWidget {
  @override
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> {
  final urlInputController = TextEditingController();

  saveUrlToDatabase(String url) async {
    String alertDialog = "";
    bool notAlertWarning = true;
    var rawUrl = url.split('/');

    if (rawUrl.last == "")
      rawUrl.removeAt(rawUrl.length - 1);

    if(rawUrl.length >= 6 && url.contains("https://serienstream.sx/serie/stream/")) {
      String result = rawUrl
          .sublist(0,6)
          .join('/');

      notAlertWarning = await HttpService.getDataSaveInDb(result);
      setState(() {});

      if (!notAlertWarning)
        alertDialog = "The Series already exists if you not find your serie restart app or contact the Developer";
    }
    else {
      alertDialog = "Url is not correct it should look like: \n https://serienstream.sx/serie/stream/[and the series]";
      notAlertWarning = false;
    }

    if (notAlertWarning) {
      setState(() {
        urlInputController.text = "";
      });
      Navigator.pop(context);
    }
    else
      return showAlertDialog(alertDialog);
  }

  Future<Widget> showAlertDialog(String alerts) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Error"),
        content: Text(alerts),
        actions: [
          CupertinoDialogAction(child: Text("Ok"), onPressed: () => Navigator.pop(context))
        ],
      ),
    );
  }

  showPopUpForAddLink(){
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: Text("Add Series"),
            content: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: CupertinoTextField(
                controller: urlInputController,
                placeholder: "Beispiel 'http://serienstream.sx/serie\n/stream/the-walking-dead/'",
                maxLines: 4,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.black,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white70
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(child: Text("Cancel"),onPressed: () => Navigator.pop(context)),
              CupertinoDialogAction(child: Text("Save"),onPressed: () {

                saveUrlToDatabase(urlInputController.text);
              })
            ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.teal,
        middle: Text("Serien", style: TextStyle(color: CupertinoColors.white)),
        leading: GestureDetector(
          child: Icon(Icons.search,color: CupertinoColors.white),
        ),
        trailing: GestureDetector(
          onTap: () => showPopUpForAddLink(),
          child: Icon(Icons.add,color: CupertinoColors.white),
        ),
      ),
      child: CategoryView()
    );
  }
}
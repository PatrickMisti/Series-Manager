import 'package:flutter/cupertino.dart';

class AlertDialogForNotification {
  static const routeName = '/detail';

  static bool activeDialog = false;

  static showDialogAlert(context,active) {
    if(active == true) {
      return showCupertinoDialog(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(
              title: new Text('Notification'),
              content: new Text('Serie already exist'),
              actions: [
                CupertinoDialogAction(
                  child: Text("Gotcha!"),
                  onPressed: () {
                    activeDialog = false;
                    Navigator.pop(context);
                  },
                )
              ],
            ),
      );
    }
    else
      return Container();
  }
}
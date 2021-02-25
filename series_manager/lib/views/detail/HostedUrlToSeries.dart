import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HostedUrlToSeries extends StatelessWidget {
  final List<Map> _hostedUrlList;
  final String _seriesUrl;

  HostedUrlToSeries(this._hostedUrlList,this._seriesUrl);

  //todo get list of hostedLanguage so implement for language tap bar but in cupertino it does not work

  launchUrlToBrowser(String hostUrl) async {
    String resultUrl = _seriesUrl.split('/').sublist(0,3).join("/");
    String toLaunchUrl = resultUrl + hostUrl;

    if (await canLaunch(toLaunchUrl))
      await launch(toLaunchUrl);
    else
      throw 'Could not launch $toLaunchUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _hostedUrlList.length,
          itemBuilder: (context, index) {
            Map hostLinks = _hostedUrlList[index];
            return GestureDetector(
              onTap: () => launchUrlToBrowser(hostLinks["hostlink"].toString()),
              child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(
                        color: CupertinoColors.white,
                        width: 4,
                        style: BorderStyle.solid)),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          hostLinks["hosttitle"].toString(),
                          style:
                              TextStyle(color: CupertinoColors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:series_manager/data/entities/manager.dart';
import 'package:url_launcher/url_launcher.dart';

class HostedUrlToSeries extends StatefulWidget{
  final List<HosterLanguageManager> _hostedUrlList;
  final String _url;

  HostedUrlToSeries(this._hostedUrlList, this._url);

  @override
  _HostedUrlToSeries createState() => _HostedUrlToSeries(_hostedUrlList.first.id);
}

class _HostedUrlToSeries extends State<HostedUrlToSeries> {

  int segmentControlValue;

  _HostedUrlToSeries(this.segmentControlValue);

  launchUrlToBrowser(String hostUrl) async {
    String resultUrl = widget._url.split('/').sublist(0, 3).join("/");
    String toLaunchUrl = resultUrl + hostUrl;

    if (await canLaunch(toLaunchUrl))
      await launch(toLaunchUrl);
    else
      throw 'Could not launch $toLaunchUrl';
  }

  buildHostUi(String browserUrl,String name) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () => launchUrlToBrowser(browserUrl),
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
                  name,
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
  }

  @override
  Widget build(BuildContext context) {
    List<HosterLanguageManager> langHoster = widget._hostedUrlList;
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: langHoster.length >= 2 
                ? CupertinoSlidingSegmentedControl(
                groupValue: segmentControlValue,
                backgroundColor: Colors.teal,
                children: Map.fromIterable(langHoster, key: (k) => k.id, value: (v) => Text(v.language)),
                onValueChanged: (value) {
                  setState(() {
                    segmentControlValue = value;
                  });
                }
            )
            :Container(

              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Center(child: Text(langHoster.first.language),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemExtent: 80,
              itemCount: langHoster.where((element) => element.id == segmentControlValue).toList().first.hosterManagerList.length,
              itemBuilder: (_, index) {
                HosterLanguageManager manager = langHoster.where((element) => element.id == segmentControlValue).toList().first;
                return buildHostUi(manager.hosterManagerList[index].browserurl, manager.hosterManagerList[index].name);
              },
            ),
          )
        ],
      ),
    );
  }
}
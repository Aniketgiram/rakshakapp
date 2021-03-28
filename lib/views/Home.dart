import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:rakshak/services/Covid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rakshak/views/selfAssessment.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Covid> futureCovid;
  String LastUpdated = "Featching data";
  var dataLocal;

  var risk;

  var quarantineLocation;
  bool isquarantine = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCovid = fetchCovid();
    futureCovid.then((val) {
      if (this.mounted) {
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted = formatter.format(DateTime.parse(val.Date));
        val.Date = formatted; // something like 2013-04-20
        setState(() {
          this.LastUpdated = "${tr("lastupdated")} " + val.Date;
        });
      }
    });

    getData().then((value) => setState(() {
          this.risk = value["risk"];
          if(value["isquarantine"] != null){
            if(value["isquarantine"]){
              setState(() {
                isquarantine = true;
                quarantineLocation = value["quarantineLocation"];
              });
            }
          }
        }));
  }

  Future<Map> getData() async {
    var data = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data["risk"] = prefs.getString("risk");
    data["quarantineLocation"] = prefs.getString("quarantineLocation");
    data["isquarantine"] = prefs.getBool("isquarantine");
    return data;
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Card(
                  color: Colors.blueAccent,
                  elevation: 5.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Your Risk Is $risk",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.assessment),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(tr("selfass")),
                                ],
                              ),
                              onPressed: () {
                                UpdateData();
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SelfAssessment(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var curve = Curves.ease;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isquarantine ? Container(
                child: Card(
                  color: Colors.blueAccent,
                  elevation: 5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0,left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                "Your are Quarantined at $quarantineLocation",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0),
                        child: Text("Please don't go outside $quarantineLocation",style: TextStyle(color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 2,
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.assessment),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(tr("changestatus")),
                                  ],
                                ),
                                onPressed: () {
                                  UpdateData();
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SelfAssessment(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      tr("updates"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      LastUpdated,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green[300].withOpacity(0.03),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Wrap(
                  children: <Widget>[
                    FutureBuilder<Covid>(
                      future: futureCovid,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Wrap(
                            runSpacing: 8,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InfoCard(
                                  title: tr("confirm"),
                                  iconColor: Colors.blueAccent,
                                  effected: snapshot.data.Confirmed.toString(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InfoCard(
                                  title: tr("death"),
                                  iconColor: Colors.red,
                                  effected: snapshot.data.Deaths.toString(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InfoCard(
                                  title: tr("recovered"),
                                  iconColor: Colors.green,
                                  effected: snapshot.data.Recovered.toString(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InfoCard(
                                  title: tr("new"),
                                  iconColor: Colors.orangeAccent,
                                  effected: snapshot.data.Active.toString(),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("precautions"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        "assets/images/hand_wash.svg"),
                                    Text(
                                      tr("handwash"),
                                      style: TextStyle(color: Colors.green),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        "assets/images/use_mask.svg"),
                                    Text(
                                      tr("usemask"),
                                      style: TextStyle(color: Colors.green),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        "assets/images/Clean_Disinfect.svg"),
                                    Text(
                                      tr("cleandisinfect"),
                                      style: TextStyle(color: Colors.green),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: LinearGradient(colors: [
                                  Colors.blueAccent,
                                  Colors.blue[300]
                                ])),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.person_outline,color: Colors.white),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(tr("callacounsellor"),style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                      onPressed: () {
//                                        CallNumber().callNumber("08448449428");
                                        launch("tel://08448449428");
                                      },
                                    ),
                                    RawMaterialButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.local_pharmacy,color: Colors.white,),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(tr("calladoctor"),style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                      onPressed: () {
//                                        CallNumber().callNumber("09513615550");
                                        launch("tel://09513615550");
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.airport_shuttle,color: Colors.white),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(tr("callanambulance"),style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                      onPressed: () {
//                                        CallNumber().callNumber("108");
                                        launch("tel://108");
                                      },
                                    ),
                                    RawMaterialButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.phone,color: Colors.white),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(tr("helplineno"),style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                      onPressed: () {
//                                        CallNumber().callNumber("104");
                                        launch("tel://104");
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future UpdateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("whantSelfAssessAgain", true);
  }

  Future<Covid> fetchCovid() async {
    final response =
        await http.get('https://api.covid19api.com/total/country/india');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,

      // then parse the JSON.
      var data = json.decode(response.body);
      return Covid.fromJson(data[data.length - 1]);
    } else {
      print("waitnot");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String effected;
  final Color iconColor;

  InfoCard(
      {Key key,
      @required this.title,
      @required this.effected,
      @required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth / 2 - 10,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 20,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/running.svg",
                        height: 12,
                        width: 12,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: iconColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
                        text: "${effected}"),
                  ]),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

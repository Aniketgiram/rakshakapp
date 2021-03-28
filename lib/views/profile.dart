import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/services/authservice.dart';
import 'package:rakshak/views/login.dart';
import 'package:rakshak/views/selfAssessment.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var dataLocal;

  String name = "Name";
  String _base64;
  double lat = 0.0;
  double lng = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((data) {
      setState(() {
        this.name = data["name"];
        this.lat = data["lat"];
        this.lng = data["lng"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
//                color: Colors.blueAccent,
                    textColor: Colors.blueAccent,
                    child: Text(tr("changestatus")),
                    onPressed: () {
                      UpdateData();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SelfAssessment(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ));
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(tr("selfass")),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      UpdateData();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SelfAssessment(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ));
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text(name),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: (){
                  Share.share("Hey check out this App");
                },
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text("Share app"),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.blueAccent,
                          child: Text("Logout",style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            AuthService().signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                      LoginPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),(Route<dynamic> route) => false);
                          }),
                    ),
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



  Future<Map> getData() async {
    var data = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data["name"] = prefs.getString("name");
    data["lat"] = prefs.getDouble("latitude");
    data["lng"] = prefs.getDouble("longitude");
    return data;
  }
}

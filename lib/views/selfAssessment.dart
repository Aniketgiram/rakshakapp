import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/views/dashboard.dart';
import 'package:rakshak/views/login.dart';

enum Progress { better, nochange, worse }

class SelfAssessment extends StatefulWidget {
  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  TextEditingController migratedController;

  TextEditingController qurantinecontroller;

  @override
  void initState() {
    // TODO: implement initState
    getData().then((val) {
      print(val);
      if (val) {
        getDataFromSharedPrefrences().then((value) {
          setState(() {
            this.age = value["age"];
            this.gender = value["gender"];
            if (gender == 'female') {
              isFemale = true;
            }
          });
          if(value["isQuarantine"] != null){
            if(value["isQuarantine"]){
              setState(() {
                this.qurantinecontroller = TextEditingController(text: value["quarantineLocation"]);
                this.isquarantine = true;
              });
            }
          }
          if(value["travelHistory"] != null){
            if(value["travelHistory"]){
              setState(() {
                this.ismigrated = true;
                this.migrateValue = value["traveltype"];
                this.migratedController = TextEditingController(text:value["travelHistoryLocation"]);
              });
            }
          }
          if(value["dib"] != null){
            if(value["dib"]){
              setState(() {
                this.diabetes = true;
              });
            }
          }
          if(value["hbp"] != null){
            if(value["hbp"]){
              setState(() {
                this.highbp = true;
              });
            }
          }
          if(value["kd"] != null){
            if(value["kd"]){
              setState(() {
                this.kidneydisease = true;
              });
            }
          }
          if(value["ld"] != null){
            if(value["ld"]){
              setState(() {
                this.lungdisease = true;
              });
            }
          }
          if(value["hd"] != null){
            if(value["hd"]){
              setState(() {
                this.heartdisease = true;
              });
            }
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Dashboard(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
      }
    }).catchError((err) {
      print("err $err");
    });

    super.initState();
  }

  // ignore: missing_return
  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isSelfAssessed") &&
        prefs.containsKey("whantSelfAssessAgain")) {
      if (prefs.getBool("whantSelfAssessAgain")) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<Map> getDataFromSharedPrefrences() async {
    var data = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("data")){
      var newdata = json.decode(prefs.getString("data"));
      data["isQuarantine"] = (newdata["isQuarantine"]);
      data["travelHistory"] = (newdata["travelHistory"]);
      data["quarantineLocation"] = (newdata["quarantineLocation"]);
      data["travelHistoryLocation"] = (newdata["travelHistoryLocation"]);
      data["traveltype"] = (newdata["traveltype"]);
      data["dib"] = newdata["diabetes"];
      data["hbp"] = newdata["highbp"];
      data["kd"] = newdata["kidneydisease"];
      data["ld"] = newdata["lungdisease"];
      data["hd"] = newdata["heartdisease"];
    }

    if(prefs.containsKey("age")){
      data["age"] = prefs.getInt("age");
      data["gender"] = prefs.getString("gender");
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
    }


    return data;
  }

  var dataLocal;
  final _formKey = GlobalKey<FormState>();
  var age;
  var totalpoint = 0;
  var totalpointl2 = 0;
  String tempValue = "Select";

  String gender;
  bool notFind1 = false;

  bool notFind = false;

  Progress progress = Progress.better;

  String ismigratedValue;

  String migratedropdownValue;

  String migrateValue = "Select";

  var data = Map();

  bool tempreature = false;

  bool musleAche = false;

  bool chills = false;

  bool trubleBreath = false;

  bool cough = false;

  bool lostest = false;

  bool nausea = false;

  bool diabetes = false;

  bool highbp = false;

  bool kidneydisease = false;

  bool lungdisease = false;

  bool heartdisease = false;

  bool collapse = false;

  bool trubleBreath1 = false;

  bool isPregnent = false;

  bool isFemale = false;

  bool isquarantine = false;

  bool ismigrated = false;

  String quarantineLocation;

  String risk;

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Nunito"),
        home: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FlatButton(
                onPressed: () {
                  print('Translate');
                  _showTranslateDialog();
                },
                child: Icon(Icons.g_translate),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: FlatButton(
                  child: Text(
                    tr("appName"),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            tr("filldetails"),
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          isFemale
                              ? ListTile(
                                  leading: Checkbox(
                                    value: isPregnent,
                                    onChanged: (bool val) {
                                      setState(() {
                                        isPregnent = !isPregnent;
                                      });
                                    },
                                  ),
                                  title: Text(tr("isPregnent")),
                                )
                              : Container(),
                          ListTile(
                            leading: Checkbox(
                              value: ismigrated,
                              onChanged: (bool val) {
                                setState(() {
                                  ismigrated = !ismigrated;
                                });
                              },
                            ),
                            title: Text(tr("ismigrated")),
                          ),
                          ismigrated
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: migrateValue,
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              migrateValue = newValue;
                                            });
                                          },
                                          items: <String>[
                                            'Select',
                                            'Domestic',
                                            'International'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ismigrated
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: migratedController,
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Where",
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return tr("plzfill");
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        this.ismigratedValue = value;
                                      });
                                    },
                                  ),
                                )
                              : Container(),
                          ListTile(
                            leading: Checkbox(
                              value: isquarantine,
                              onChanged: (bool val) {
                                setState(() {
                                  isquarantine = !isquarantine;
                                });
                              },
                            ),
                            title: Text(tr("quarantine")),
                          ),
                          isquarantine
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: qurantinecontroller,
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Where",
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return tr("plzfill");
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        this.quarantineLocation = value;
                                      });
                                    },
                                  ),
                                )
                              : Container(),
                          Text(tr("symptoms1")),
                          ListTile(
                            leading: Checkbox(
                              value: tempreature,
                              onChanged: (bool val) {
                                setState(() {
                                  tempreature = !tempreature;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("bodyTemperature")),
                          ),
                          tempreature
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: tempValue,
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              tempValue = newValue;
                                            });
                                          },
                                          items: <String>[
                                            'Select',
                                            'Normal',
                                            'Fever',
                                            'High Fever',
                                            'Dont know'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ListTile(
                            leading: Checkbox(
                              value: cough,
                              onChanged: (bool val) {
                                setState(() {
                                  cough = !cough;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("cough")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: trubleBreath,
                              onChanged: (bool val) {
                                setState(() {
                                  trubleBreath = !trubleBreath;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("trubleBreath")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: chills,
                              onChanged: (bool val) {
                                setState(() {
                                  chills = !chills;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("chills")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: musleAche,
                              onChanged: (bool val) {
                                setState(() {
                                  musleAche = !musleAche;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("musleAche")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: lostest,
                              onChanged: (bool val) {
                                setState(() {
                                  lostest = !lostest;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("lostest")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: nausea,
                              onChanged: (bool val) {
                                setState(() {
                                  nausea = !nausea;
                                  notFind = false;
                                });
                              },
                            ),
                            title: Text(tr("nausea")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: notFind,
                              onChanged: (bool val) {
                                setState(() {
                                  notFind = !notFind;
                                  tempreature = false;
                                  cough = false;
                                  trubleBreath = false;
                                  chills = false;
                                  musleAche = false;
                                  lostest = false;
                                  nausea = false;
                                });
                              },
                            ),
                            title: Text(tr("notFind")),
                          ),
                          Text(tr("isdiseases")),
                          ListTile(
                            leading: Checkbox(
                              value: diabetes,
                              onChanged: (bool val) {
                                setState(() {
                                  diabetes = !diabetes;
                                  notFind1 = false;
                                });
                              },
                            ),
                            title: Text(tr("diabetes")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: highbp,
                              onChanged: (bool val) {
                                setState(() {
                                  highbp = !highbp;
                                  notFind1 = false;
                                });
                              },
                            ),
                            title: Text(tr("highbp")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: kidneydisease,
                              onChanged: (bool val) {
                                setState(() {
                                  kidneydisease = !kidneydisease;
                                  notFind1 = false;
                                });
                              },
                            ),
                            title: Text(tr("kidneydisease")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: lungdisease,
                              onChanged: (bool val) {
                                setState(() {
                                  lungdisease = !lungdisease;
                                  notFind1 = false;
                                });
                              },
                            ),
                            title: Text(tr("lungdisease")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: heartdisease,
                              onChanged: (bool val) {
                                setState(() {
                                  heartdisease = !heartdisease;
                                  notFind1 = false;
                                });
                              },
                            ),
                            title: Text(tr("heartdisease")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: notFind1,
                              onChanged: (bool val) {
                                setState(() {
                                  notFind1 = !notFind1;
                                  diabetes = false;
                                  highbp = false;
                                  kidneydisease = false;
                                  lungdisease = false;
                                  heartdisease = false;
                                });
                              },
                            ),
                            title: Text(tr("notFind")),
                          ),
                          Text(tr("progress")),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: Progress.better,
                                groupValue: progress,
                                onChanged: (Progress value) {
                                  setState(() {
                                    progress = value;
                                  });
                                },
                              ),
                              Text(tr("better")),
                              Radio(
                                value: Progress.nochange,
                                groupValue: progress,
                                onChanged: (Progress value) {
                                  setState(() {
                                    progress = value;
                                  });
                                },
                              ),
                              Text(tr("nochange")),
                              Radio(
                                value: Progress.worse,
                                groupValue: progress,
                                onChanged: (Progress value) {
                                  setState(() {
                                    progress = value;
                                  });
                                },
                              ),
                              Text(tr("worse")),
                            ],
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: trubleBreath1,
                              onChanged: (bool val) {
                                setState(() {
                                  trubleBreath1 = !trubleBreath1;
                                });
                              },
                            ),
                            title: Text(tr("trubleBreath1")),
                          ),
                          ListTile(
                            leading: Checkbox(
                              value: collapse,
                              onChanged: (bool val) {
                                setState(() {
                                  collapse = !collapse;
                                });
                              },
                            ),
                            title: Text(tr("collapse")),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 55,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Colors.blueAccent[400],
                              child: Text(tr('submit'),
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  data["age"] = age;
                                  // Process data.
                                  totalpoint = 0;
                                  totalpointl2 = 0;
                                  if (isquarantine) {
                                    data["isQuarantine"] = isquarantine;
                                    if(quarantineLocation == null){
                                      data["quarantineLocation"] =
                                         qurantinecontroller.text;
                                    }else{
                                      data["quarantineLocation"] =
                                          quarantineLocation;
                                    }
                                  }
                                  if (ismigrated) {
                                    if (migrateValue == 'Select') {
                                      _showMyDialog("Enter Travel data");
                                      return;
                                    } else if (migrateValue == 'Domestic') {
                                      totalpoint += 5;
                                      data["travelHistory"] = ismigrated;
                                      data["traveltype"] = "Domestic";
                                      if(ismigratedValue == null){
                                        data["travelHistoryLocation"] =
                                            migratedController.text;
                                      }else{
                                        data["travelHistoryLocation"] =
                                            ismigratedValue;
                                      }
                                    } else if (migrateValue ==
                                        'International') {
                                      totalpoint += 8;
                                      data["travelHistory"] = ismigrated;
                                      data["traveltype"] = "International";
                                      if(ismigratedValue == null){
                                        data["travelHistoryLocation"] =
                                            ismigratedValue;
                                      }else{
                                        data["travelHistoryLocation"] =
                                            migratedController.text;
                                      }
                                    }
                                  }

                                  if (age <= 3) {
                                    totalpoint += 20;
                                  } else if ((3 < age && age <= 10) ||
                                      (45 < age && age <= 60)) {
                                    totalpoint += 10;
                                  } else if (10 < age && age < 18) {
                                    totalpoint += 5;
                                  } else if (60 < age) {
                                    totalpoint += 10;
                                  }
                                  if (gender == "male") {
                                    totalpoint += 5;
                                    data["gender"] = "male";
                                  } else if (gender == "female") {
                                    if (isPregnent) {
                                      totalpoint += 7;
                                      data["gender"] = "female";
                                      data["isPregnent"] = isPregnent;
                                    } else {
                                      totalpoint += 3;
                                      data["gender"] = "female";
                                      data["isPregnent"] = isPregnent;
                                    }
                                  } else if (gender == "other") {
                                    totalpoint += 4;
                                    data["gender"] = "other";
                                  }

                                  if (tempreature) {
                                    if (tempValue == 'Select') {
                                      _showMyDialog("Enter Tempreature");
                                      return;
                                    } else if (tempValue == 'Normal') {
                                      totalpoint += 2;
                                      data["tempreature"] = tempreature;
                                      data["tempreatureLevel"] = "Normal";
                                    } else if (tempValue == 'Fever') {
                                      totalpoint += 8;
                                      data["tempreature"] = tempreature;
                                      data["tempreatureLevel"] = "Fever";
                                    } else if (tempValue == 'High Fever') {
                                      totalpoint += 11;
                                      data["tempreature"] = tempreature;
                                      data["tempreatureLevel"] = "High Fever";
                                    } else if (tempValue == 'Dont know') {
                                      totalpoint += 5;
                                      data["tempreature"] = tempreature;
                                      data["tempreatureLevel"] = "Don't Know";
                                    }
                                  } else {
                                    data["tempreature"] = tempreature;
                                  }
                                  if (musleAche) {
                                    totalpoint += 6;
                                    data["musleAche"] = musleAche;
                                  } else {
                                    data["musleAche"] = musleAche;
                                  }
                                  if (chills) {
                                    totalpoint += 6;
                                    data["chills"] = chills;
                                  } else {
                                    data["chills"] = chills;
                                  }
                                  if (trubleBreath) {
                                    totalpoint += 10;
                                    data["trubleBreath"] = trubleBreath;
                                  } else {
                                    data["trubleBreath"] = trubleBreath;
                                  }
                                  if (cough) {
                                    totalpoint += 6;
                                    data["cough"] = cough;
                                  } else {
                                    data["cough"] = cough;
                                  }
                                  if (lostest) {
                                    totalpoint += 6;
                                    data["lostest"] = lostest;
                                  } else {
                                    data["lostest"] = lostest;
                                  }
                                  if (nausea) {
                                    totalpoint += 6;
                                    data["nausea"] = nausea;
                                  } else {
                                    data["nausea"] = nausea;
                                  }
                                  if (diabetes) {
                                    totalpointl2 += 7;
                                    data["diabetes"] = diabetes;
                                  } else {
                                    data["diabetes"] = diabetes;
                                  }
                                  if (highbp) {
                                    totalpointl2 += 7;
                                    data["highbp"] = highbp;
                                  } else {
                                    data["highbp"] = highbp;
                                  }
                                  if (kidneydisease) {
                                    totalpointl2 += 7;
                                    data["kidneydisease"] = kidneydisease;
                                  } else {
                                    data["kidneydisease"] = kidneydisease;
                                  }
                                  if (lungdisease) {
                                    totalpointl2 += 7;
                                    data["lungdisease"] = lungdisease;
                                  } else {
                                    data["lungdisease"] = lungdisease;
                                  }
                                  if (heartdisease) {
                                    totalpointl2 += 7;
                                    data["heartdisease"] = heartdisease;
                                  } else {
                                    data["heartdisease"] = heartdisease;
                                  }

                                  if (progress == Progress.better) {
                                    totalpoint += totalpointl2;
                                    totalpoint -= 2 * totalpointl2;
                                    data["progress"] = "better";
                                  } else if (progress == Progress.nochange) {
                                    totalpoint += totalpointl2;
                                    totalpoint += 3 * totalpointl2;
                                    data["progress"] = "nochange";
                                  } else if (progress == Progress.worse) {
                                    totalpoint += totalpointl2;
                                    totalpoint += 6 * totalpointl2;
                                    data["progress"] = "worse";
                                  }

                                  if (collapse) {
                                    totalpoint *= 1.5.ceil();
                                    data["collapse"] = collapse;
                                  } else {
                                    data["collapse"] = collapse;
                                  }
                                  if (trubleBreath1) {
                                    totalpoint *= 2;
                                    data["trubleBreath1"] = trubleBreath1;
                                  } else {
                                    data["trubleBreath1"] = trubleBreath1;
                                  }
                                  var finalpoint =
                                      (((totalpoint - 3) * (10 - 0)) /
                                          (200 - 3));
                                  finalpoint = finalpoint.ceil().ceilToDouble();
                                  print(finalpoint);
                                  if (finalpoint > 7) {
                                    print("high");
                                    setState(() {
                                      this.risk = "High";
                                      data["risk"] = "High";
                                    });
                                  } else if (finalpoint < 4) {
                                    print("LOw");
                                    setState(() {
                                      this.risk = "Low";
                                      data["risk"] = "Low";
                                    });
                                  } else {
                                    print("medium");
                                    setState(() {
                                      this.risk = "Medium";
                                      data["risk"] = "Medium";
                                    });
                                  }

                                  saveData();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("data", json.encode(data));
    prefs.setString("risk", risk);
    prefs.setBool("isSelfAssessed", true);
    prefs.setBool("whantSelfAssessAgain", false);
    if(quarantineLocation == null){
      if(isquarantine)
      prefs.setString("quarantineLocation", qurantinecontroller.text);
    }else{
      prefs.setString("quarantineLocation", quarantineLocation);
    }

    prefs.setBool("isquarantine", isquarantine);
    print(data);
    SaveDatatoDB().then((value) {
      if (value) {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Dashboard(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
      }
    });
  }

  Future<bool> SaveDatatoDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("phoneno")) {
      var no = prefs.getString("phoneno");
      Firestore.instance
          .collection('users')
          .document("$no").collection("testdata").document()
          .setData({'data': data, 'flag': false});
      return true;
    } else {
      return false;
    }
  }

  Future<void> _showTranslateDialog() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  leading: Text(tr("selectlang")),
                  trailing: GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                ListTile(
                    leading: new Icon(Icons.g_translate),
                    title: new Text('English'),
                    onTap: () {
                      setState(() {
                        dataLocal.changeLocale(locale: Locale('en', 'US'));
                        print("Local changed to marathi");
                        Navigator.of(context).reassemble();
                        Navigator.of(context).pop();
                      });
                    }),
                ListTile(
                  leading: new Icon(Icons.g_translate),
                  title: new Text('मराठी'),
                  onTap: () {
                    setState(() {
                      dataLocal.changeLocale(locale: Locale('mr', 'IN'));
                      print("Local changed to marathi");
                      Navigator.of(context).reassemble();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}

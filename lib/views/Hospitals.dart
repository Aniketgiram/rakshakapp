import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  var langData;

  String langselect = "en_US";

  @override
  Widget build(BuildContext context) {
    this.langData = EasyLocalizationProvider.of(context).data;
    setState(() {
      langselect = langData.locale.toString();
    });
    if (langselect == "mr_IN") {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('hospitals').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.blue[300]])),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.local_hospital,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      document["mname"],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.location_on, color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      document["maddress"],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.assessment, color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "????????? : ${document["beds"].toString()}",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.local_hospital,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "?????????????????? :  ${document["type"]}",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      );
    } else if (langselect == "en_US") {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('hospitals').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.blue[300]])),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.local_hospital,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                        document["name"][0].toUpperCase()+document["name"].substring(1),
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.location_on, color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      document["address"],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.assessment, color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Beds : ${document["beds"].toString()}",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.local_hospital,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Type : ${document["type"]}",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      );
    }
  }
}



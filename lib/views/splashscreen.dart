import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rakshak/services/location_service.dart';
import 'package:rakshak/views/langSelect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool marathi = false;
  bool english = true;
  bool showLang = false;
  bool showLoader = false;

  var dataLocal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkinternet().then((value) {
      if (value) {
        Geolocator().isLocationServiceEnabled().then((value) {
          print(value);
          if (value) {
            getData().then((value) {
              if (value) {
                setState(() {
                  this.showLang = false;
                  this.showLoader = true;
                });
                Future.delayed(Duration(seconds: 2), () {
                  locationService().checkPermission();
                  locationService().checkLocationData();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FirstScreen(),
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
                      ),
                      (Route<dynamic> route) => false);
                });
              } else {
                setState(() {
                  this.showLang = true;
                });
              }
            });
          } else {
            print("location service is disabled");
            _showMyDialog("GPS Service is not enabled.",
                "Please enable GPS of the device and open app again");
            return;
          }
        });
      } else {
        _showMyDialog("Internet Service is not enabled.",
            "Please enable Internet of the device and open app again");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Nunito"),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            showLoader
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/icon.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Rakshak",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/icon2.png",
                          height: 300,
                          width: 300,
                        ),
                      ),
                    ),
                  ],
                ),
                showLang
                    ? Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InputChip(
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "English",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              selected: english,
                              selectedColor: Colors.green,
                              onPressed: () {
                                setState(() {
                                  this.english = !this.english;
                                  this.marathi = !this.marathi;
                                  dataLocal.changeLocale(
                                      locale: Locale('en', 'US'));
                                  Navigator.of(context).reassemble();
                                });
                              },
                            ),
                            InputChip(
                              selected: marathi,
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "मराठी",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              selectedColor: Colors.green,
                              onPressed: () {
                                setState(() {
                                  this.marathi = !this.marathi;
                                  this.english = !this.english;
                                  dataLocal.changeLocale(
                                      locale: Locale('mr', 'IN'));
                                  Navigator.of(context).reassemble();
                                });
                              },
                            ),
                            FloatingActionButton(
                              child: Icon(Icons.navigate_next),
                              onPressed: () {
                                setData();
                                setState(() {
                                  this.showLoader = true;
                                });
                         Future.delayed(Duration(seconds: 2),(){
                           locationService().checkPermission();
                           locationService().checkLocationData();
                           Navigator.push(
                               context,
                               PageRouteBuilder(
                                 pageBuilder: (context, animation, secondaryAnimation) =>
                                     FirstScreen(),
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
                         });
                              },
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTime")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTime")) {
    } else {
      prefs.setBool("isFirstTime", true);
    }
  }

  Future<void> _showMyDialog(msg, submsg) async {
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
                Text(submsg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkinternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else {
      return false;
    }
  }
}

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/views/verifylogin.dart';

class Onboarding extends StatefulWidget {
  var dataLocal;

  Onboarding({Key key, @required this.dataLocal}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final int _numPages = 4;
  PageController _pageController = new PageController(initialPage: 0);
  int _currentPage = 0;

  var dataLocal;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dataLocal = widget.dataLocal;
    });
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: Scaffold(
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
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                  saveData();
                  print('Skip');
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            VerifyUser(),
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
                },
                child: Text(
                  tr("skip"),
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 250.0,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/gifs/corona.gif',
                                  ),
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                tr("corona"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/gifs/mask.gif',
                                  ),
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                tr("wearMask"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/gifs/distance.gif',
                                  ),
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                tr("socialDistance"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/gifs/staysafe.gif',
                                  ),
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                tr("stayHome"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    tr("next"),
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blueAccent,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: _currentPage == _numPages - 1
            ? GestureDetector(
                onTap: () {
                  saveData();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            VerifyUser(),
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
                },
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  color: Colors.blueAccent,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 00.0),
                      child: Text(
                        tr("continue"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Text(''),
      ),
    );
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isOnBoardShown", true);
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

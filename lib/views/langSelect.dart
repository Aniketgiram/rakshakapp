import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rakshak/services/location_service.dart';
import 'package:rakshak/views/onboarding.dart';
import 'package:rakshak/views/verifylogin.dart';

class LangSelect extends StatefulWidget {
  @override
  _LangSelectState createState() => _LangSelectState();
}

class _LangSelectState extends State<LangSelect> {
  var dataLocal;

  String lang;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = "English";
    getData().then((value){
      if(value){
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
            ),(Route<dynamic> route) => false);
      }
    });

  }

  Future<bool> getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isFirstTime")){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> setData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isFirstTime")){

    }else{
      prefs.setBool("isFirstTime", true);
    }
  }



  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: FlatButton(
                child: Text(
                  "Rakshak",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Select the Language",style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.bold,fontSize: 20.0),),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      dataLocal.changeLocale(locale: Locale('en', 'US'));
                      Navigator.of(context).reassemble();
                      lang = "English";
                    });
                  },
                  child: Card(
                      child: ListTile(
                    leading: Icon(Icons.language),
                    title: Text(
                      "English",
                      style: TextStyle(
                          fontFamily: "Nunito", fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      dataLocal.changeLocale(locale: Locale('mr', 'IN'));
                      Navigator.of(context).reassemble();
                      lang = "मराठी";
                    });
                  },
                  child: Card(
                      child: ListTile(
                    leading: Icon(Icons.language),
                    title: Text(
                      "मराठी",
                      style: TextStyle(
                          fontFamily: "Nunito", fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Selected Language : "+lang),
                      FloatingActionButton(
                        child: Icon(Icons.navigate_next),
                        onPressed: (){
                          setData();
                          Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              Onboarding(dataLocal:dataLocal),
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
                        },
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  @override
  void initState() {
    getData().then((val){
      if(val){

      }else {
        //      SchedulerBinding.instance.addPostFrameCallback((_) {
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
            ),(Route<dynamic> route) => false);
//      });
      }
    });
    super.initState();
  }

  Future<bool> getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isOnBoardShown")) {
      if (prefs.getBool("isOnBoardShown")) {
        return false;
      } else {
        return true;
      }
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onboarding(),
        theme: ThemeData(
            fontFamily: 'Nunito'
        ),
      ),
    );
  }
}

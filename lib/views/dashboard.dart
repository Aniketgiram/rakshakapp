import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/views/Home.dart';
import 'package:rakshak/views/Services.dart';
import 'package:rakshak/views/TabbedNavBar.dart';
import 'package:rakshak/views/media.dart';
import 'package:rakshak/views/profile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var risk;

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    Media(),
    Services(),
    TabbedNavBar(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  var dataLocal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Nunito'),
        home: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FlatButton(
                onPressed: () {
                  print('Translate');
                  _showTranslateDialog();
//                  Scaffold.of(context).showBottomSheet(builder);
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
          body: Container(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library),
                title: Text('Media'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call_to_action),
                title: Text('Services'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_pharmacy),
                title: Text('Hospitals'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueAccent,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
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


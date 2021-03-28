import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/views/Hospitals.dart' as hospitals;
import 'package:rakshak/views/TestLab.dart' as testlab;

class TabbedNavBar extends StatefulWidget {
  @override
  _TabbedNavBarState createState() => _TabbedNavBarState();
}

class _TabbedNavBarState extends State<TabbedNavBar> with SingleTickerProviderStateMixin {

  var dataLocal;

  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this,length: 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: Scaffold(
        appBar: TabBar(
          controller: _controller,
          labelColor: Colors.blueAccent,
          tabs: <Widget>[
            Tab(text: tr("hospital"), icon: Icon(Icons.local_hospital)),
            Tab(text: tr("testlab"), icon: Icon(Icons.list))
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            hospitals.Hospitals(),
            testlab.TestLab()
          ],
        ),
      ),
    );
  }
}

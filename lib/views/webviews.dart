import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/views/dashboard.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {

  final String link;

  Webview({Key key,@required this.link}):super(key:key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  bool _isLoadingPage;
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._isLoadingPage = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(0.0),
      ),
      body: Stack(
       children: <Widget>[
         WebView(
            initialUrl: widget.link,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
           onPageFinished: (finish) {
             setState(() {
               _isLoadingPage = false;
             });
           },
          ),
         _isLoadingPage
             ? Container(
           alignment: FractionalOffset.center,
           child: CircularProgressIndicator(),
         )
             : Container(
         ),
       ],
     ),
      floatingActionButton: _backButton(),
    );
  }

  _backButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.arrow_back_ios),
                SizedBox(width: 5.0,),
                Text("Back To App"),
              ],
            ),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
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
            },
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

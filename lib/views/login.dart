import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rakshak/services/authservice.dart';
import 'package:rakshak/views/selfAssessment.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { male, female, other }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var dataLocal;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyOTP = GlobalKey<FormState>();
  var phoneno;

  bool _loader = false;
  String verificationID, smsCode,name;

  int age;

  Gender gender = Gender.male;

  @override
  void initState() {
    // TODO: implement initState
    this._loader = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataLocal = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: dataLocal,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Nunito",scaffoldBackgroundColor: Colors.grey[300]),
        home: Scaffold(
          resizeToAvoidBottomInset: true,
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
            backgroundColor: Colors.grey[300],
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
          body: Stack(
            children:[
              SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        tr("login"),
                        style: TextStyle(fontSize: 30.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        tr("filldetails"),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(tr("firstName")),
                            ),
                            TextFormField(
                              autofocus: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Name",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr("firstName");
                                }
                                return null;
                              },
                              onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                              },
                            ),
                            SizedBox(height: 10.0,),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(tr("mobilNumber")),
                            ),
                            TextFormField(
                              autofocus: false,
                              maxLength: 10,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "9999999990",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr("validNumber");
                                }
                                if (value.length != 10) {
                                  return tr("validNumber");
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.length > 8) {
                                  setState(() {
                                    phoneno = value;
                                  });
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(tr("dateOfBirth")),
                            ),
                            TextFormField(
                              autofocus: false,
                              maxLength: 3,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '21'
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr("dateOfBirth");
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  age = int.parse(value);
                                });
                              },
                            ),
                            Text(tr("selectGender")),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: Gender.male,
                                  groupValue: gender,
                                  onChanged: (Gender value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                                Text(tr("male")),
                                Radio(
                                  value: Gender.female,
                                  groupValue: gender,
                                  onChanged: (Gender value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                                Text(tr("female")),
                                Radio(
                                  value: Gender.other,
                                  groupValue: gender,
                                  onChanged: (Gender value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                                Text(tr("other")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 15.0),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 55,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color: Colors.blueAccent[400],
                                      child: Text(tr('submit'),
                                          style: new TextStyle(
                                              fontSize: 16.0, color: Colors.white)),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            this._loader = true;
                                          });
                                          // Process data.
                                          verifyPhone(phoneno);
                                          saveData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _loader ?  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0,),
                    Text("Loading",style: TextStyle(color: Colors.blue),)
                  ],
                )
              ):Container()
            ]
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

  Future<void> saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phoneno", phoneno);
    prefs.setString("name", name);
    prefs.setInt("age", age);
    if(Gender.male == gender){
      prefs.setString("gender", "male");
    }else if(Gender.female == gender){
      prefs.setString("gender", "female");
    }else if(Gender.other == gender){
      prefs.setString("gender", "other");
    }
    print("data stored from login");
  }

  Future<void> _showOTPDialog() async {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                top: 15.0,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKeyOTP,
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: GestureDetector(child: Text(tr("tapHere"),style: TextStyle(fontFamily: 'Nunito'),),onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).reassemble();
                      },),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(tr("enterCode"),style: TextStyle(fontFamily: 'Nunito'),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(child: Text(tr("resendCode"),style: TextStyle(fontFamily: 'Nunito'),),onTap: (){
                                Navigator.of(context).pop();

                                verifyPhone(phoneno);
                              },)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "123456",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return tr("enterCode");
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length > 3) {
                            setState(() {
                              smsCode = value;
                            });
                          }
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
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
                                if (_formKeyOTP.currentState.validate()) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    this._loader = true;
                                  });
                                  AuthCredential authCredential = PhoneAuthProvider.getCredential(
                                      verificationId: verificationID, smsCode: smsCode);
                                  AuthService().signIn(authCredential).then((value) {
                                    if (value != null) {
                                      if (value["status"] == false) {
                                        setState(() {
                                          this._loader = false;
                                        });
                                        _showMyDialog("Error",
                                            value["msg"] + " Please try again");
                                        return;
                                      }
                                    } else {
                                      AuthService().signInwithOTPDataToDatabase(
                                          phoneno, name);
                                      setState(() {
                                        this._loader = false;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                SelfAssessment(),
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
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> verifyPhone(phoneno) async {
    final PhoneVerificationCompleted verified = (AuthCredential authresult) {
      print("Auth initiated");
      AuthService().storeUserdata(phoneno, name);
      AuthService().signIn(authresult).then((value){
        if(value["status"] == false){
          _showMyDialog("Authentication Failed", value["msg"]);
        }
      });
      setState(() {
        this._loader = false;
      });
    };

    final PhoneVerificationFailed verifactionfaild =
        (AuthException authException) {
      print(authException.message);
      setState(() {
        this._loader = false;
      });
      _showMyDialog("Authentication Failed", "Please try again later");
    };

    final PhoneCodeSent codesent = (String verID, [int forceResend]) {
      this.verificationID = verID;
      print("Code send");
      setState(() {
        this._loader = false;
      });
      _showOTPDialog();
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verID) {
      this.verificationID = verID;
      print("CodeAutoretrivaltimeout");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + phoneno,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verifactionfaild,
        codeSent: codesent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

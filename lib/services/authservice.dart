import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/views/login.dart';
import 'package:rakshak/views/selfAssessment.dart';

class AuthService {
//  Handles auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            return SelfAssessment();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

//  Signout
  signOut() {
    FirebaseAuth.instance.signOut();
  }

//  Signin
  Future<Map> signIn(AuthCredential authCred) async{
    Map data = Map();
    try {
      await FirebaseAuth.instance.signInWithCredential(authCred);
    } on PlatformException catch (e) {
      if (e.code.contains(
          'ERROR_INVALID_VERIFICATION_CODE')) {
        print("Code wrong");
        data["status"] = false;
        data["msg"] = "INVALID VERIFICATION CODE";
        return data;
      } else if (e.message.contains('The sms code has expired')) {
        print("OTP EXPIRED");
        data["status"] = false;
        data["msg"] = "VERIFICATION CODE EXPIRED";
        return data;
      }
    }
  }

  Future<Map> signInwithOTPDataToDatabase(phoneNo, name){
    storeUserdata(phoneNo, name);
  }

  storeUserdata(phoneNo, name) {
    Firestore.instance
        .collection('users')
        .document("${phoneNo}")
        .setData({'name': '${name}'});
  }
}



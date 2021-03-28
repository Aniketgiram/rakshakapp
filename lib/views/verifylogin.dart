import 'package:flutter/material.dart';
import 'package:rakshak/services/authservice.dart';

class VerifyUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}

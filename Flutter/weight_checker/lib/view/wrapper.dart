import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool signedIn = false;

  checkIfIsSignedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      signedIn = localStorage.getBool('isSignedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    checkIfIsSignedIn();
    return signedIn == true ? Home() : Login();
  }
}

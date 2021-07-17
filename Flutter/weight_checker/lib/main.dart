import 'package:flutter/material.dart';
import 'package:weight_checker/view/history.dart';
import 'package:weight_checker/view/home.dart';
import 'package:weight_checker/view/login.dart';
import 'package:weight_checker/view/wrapper.dart';

void main() {
  runApp(MaterialApp(
    home: Wrapper(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/wrapper': (context) => Wrapper(),
      '/homepage': (context) => Home(),
      '/login': (context) => Login(),
      '/historypage': (context) => History(),
    },
  ));
}

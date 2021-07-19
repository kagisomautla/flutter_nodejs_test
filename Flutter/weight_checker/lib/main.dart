import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weight_checker/view/history.dart';
import 'package:weight_checker/view/home.dart';
import 'package:weight_checker/view/login.dart';
import 'package:weight_checker/view/wrapper.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

import 'package:flutter/material.dart';
import 'package:weight_checker/view/history.dart';
import 'package:weight_checker/view/home.dart';
import 'package:weight_checker/view/wrapper.dart';

void main() {
  runApp(MaterialApp(
    home: Wrapper(),
    debugShowCheckedModeBanner: false,
    routes: {
      //This evaluation checks if a user has a token or not:
      //If there isn't a token, a user isn't logged in, therefore they'll be routed to the authentication page
      //If there is a token, the user is logged in, therefore they'll be routed to the landing page.
      '/wrapper': (context) => Wrapper(),
      '/homepage': (context) => Home(),
      //'/driver_home': (context) => DriverHome(),
      '/historypage': (context) => History(),
    },
  ));
}

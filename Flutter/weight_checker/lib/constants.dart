import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelText: '',
  labelStyle: TextStyle(
    fontFamily: 'Righteous',
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
  fillColor: Colors.white,
  filled: true,
  hintStyle: TextStyle(
    fontFamily: 'Righteous',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  errorStyle: TextStyle(
    fontFamily: 'Righteous',
    fontSize: 15,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
);

var universalTextStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Righteous',
  color: Colors.black,
);

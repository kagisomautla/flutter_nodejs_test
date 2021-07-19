import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_checker/model/api_services.dart';
import 'package:weight_checker/view/home.dart';
import 'package:weight_checker/view/sign_up.dart';
import 'package:weight_checker/view/wrapper.dart';

import '../constants.dart';
import '../loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    ));
  }

  _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String _url = '/login';
      var data = {
        'email': validateEmail(emailController),
        'password': passwordController.text.trim(),
      };

      final response = await Api().postData(data, _url);
      Map<String, dynamic> body = json.decode(response.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setInt('user_id', body['user_id']);
      print(body);

      if (body['status'] != "success") {
        _showMsg(body["message"]);
      } else {
        localStorage.setBool('isSignedIn', true);

        Navigator.popAndPushNamed(context, '/wrapper');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  var _token;

  String validateEmail(TextEditingController eController) {
    String e;
    e = eController.text.trim().toLowerCase();
    if (e.contains('@') &&
        (e.endsWith('.com') || e.endsWith('.co.za') || e.endsWith('.bw'))) {
      return e;
    } else {
      return null;
    }
  }

  bool _isLoading = false;

  var userModel;

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return _token != null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.teal[300],
                height: screenH,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: universalTextStyle.copyWith(
                          fontFamily: 'Fuggles',
                          fontSize: 75,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: TextFormField(
                          controller: emailController,
                          onChanged: (value) => email = value,
                          validator: (value) => value.isEmpty
                              ? _showMsg('Enter a valid email.')
                              : null,
                          decoration: textInputDecoration.copyWith(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[300],
                                width: 1.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[400],
                                width: 1.0,
                              ),
                            ),
                            labelText: 'email',
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) => value.length < 8
                              ? _showMsg(
                                  'Password must contain at least 8 characters.')
                              : null,
                          onChanged: (value) => password = value,
                          decoration: textInputDecoration.copyWith(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[300],
                                width: 1.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[400],
                                width: 1.0,
                              ),
                            ),
                            labelText: 'password',
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: _isLoading == true
                            ? SpinKitPulse(
                                size: 30,
                                color: Colors.white,
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                onPressed: () async {
                                  // Action what should happened when button is clicked
                                  if (_formKey.currentState.validate()) {
                                    _login();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'sign in',
                                    style: universalTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Don\'t have an account?',
                                        style: universalTextStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            //Action what should happen when link is pressed
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()),
                                            );
                                          },
                                          child: Container(
                                            child: Text(
                                              'Sign Up',
                                              style:
                                                  universalTextStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

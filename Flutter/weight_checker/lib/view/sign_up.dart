import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_checker/model/api_services.dart';
import 'package:weight_checker/view/wrapper.dart';
import '../constants.dart';
import '../loading.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //snackbar
  _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    ));
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = '';
  String password = '';
  String confirmPassword = '';

  var _token;
  bool errorPassword = false;
  bool _isLoading = false;

  _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String _url = '/sign_up';
      var data = {
        'email': validateEmail(emailController),
        'password': passwordController.text.trim(),
      };

      final response = await Api().postData(data, _url);
      Map<String, dynamic> body = json.decode(response.body);
      print(body["status"]);
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      if (body != null) {
        localStorage.setBool('isSignedIn', true);
        localStorage.setInt('user_id', body['user_id']);

        if (body['status'] == "success") {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => Wrapper()),
          );
        } else {
          _showMsg('User with the same email aready exists.');
        }
      } else {
        _showMsg('User with the same email aready exists.');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // signup("princeruz@gmail.com", "12345678");
    return _token != null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.teal[300],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up!',
                        style: universalTextStyle.copyWith(
                          fontFamily: 'Fuggles',
                          fontSize: 75,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Create your account.',
                        style: universalTextStyle.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: emailController,
                        onChanged: (value) => email = value,
                        validator: (value) => value.isEmpty
                            ? _showMsg('Please enter a valid email')
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
                      SizedBox(height: 5),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (value) => password = value,
                        validator: (value) => value.length < 8
                            ? _showMsg(
                                'Password must contain at least 8 characters')
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
                          labelText: 'password',
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        onChanged: (value) => confirmPassword = value,
                        validator: (value) => value.length < 8 ? '' : null,
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
                            borderSide: errorPassword == true
                                ? BorderSide(
                                    color: Colors.red[500],
                                    width: 2.0,
                                  )
                                : BorderSide(
                                    color: Colors.grey[300], width: 1.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                              width: 1.0,
                            ),
                          ),
                          labelText: 'confirm password',
                        ),
                      ),
                      password != confirmPassword
                          ? Row(
                              children: [
                                Text(
                                  'Passwords do not match.',
                                  style: universalTextStyle.copyWith(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : Text(''),
                      SizedBox(
                        height: 25,
                      ),
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
                                  //Action what should happened when button is clicked
                                  if (_formKey.currentState.validate()) {
                                    if (password != confirmPassword) {
                                      _showMsg(
                                          'Passwords do not match. Try again.');
                                    } else {
                                      _signUp();
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'sign up',
                                    style: universalTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Already have an account?',
                                style: universalTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: () =>
                                        Navigator.pop(context, '/login'),
                                    child: Text(
                                      'Sign In',
                                      style: universalTextStyle.copyWith(
                                        fontSize: 15,
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
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

// signup(email, password) async {
//   var url = "http://192.168.8.110:3000/sign_up"; // iOS
//   final response = await http.post(
//     url,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'email': email,
//       'password': password,
//     }),
//   );
//   print(response.body);
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var parse = jsonDecode(response.body);

//   await prefs.setString('token', parse["token"]);
// }

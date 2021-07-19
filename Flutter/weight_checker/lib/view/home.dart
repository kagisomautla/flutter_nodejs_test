import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_checker/model/api_services.dart';
import '../constants.dart';
import '../nav_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading;
  double weight;

  TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  saveWeight() async {
    var dt = DateTime.now();
    var dateFormat = DateFormat("yy-MM-dd");
    String createdOn = dateFormat.format(dt);
    print(createdOn);
    int user_id;
    setState(() {
      _isLoading = true;
    });

    try {
      final String _url = '/save_weight';
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      user_id = localStorage.getInt('user_id');
      print(user_id);

      var data = {
        'weight': weight.toString(),
        'created_on': createdOn,
        'user_id': user_id,
      };

      final response = await Api().postData(data, _url);
      Map<String, dynamic> body = json.decode(response.body);

      if (body['status'] == 'success') {
        _showMsg('New weight added.');
      } else {
        _showMsg('Could not new weight');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        elevation: 0.0,
        child: NavDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          'Weight Check\'r',
          style: universalTextStyle.copyWith(),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: weightController,
                    validator: (value) => value.length == 0
                        ? _showMsg('Weight may not be empty')
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
                      labelText: 'Enter your weight here',
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.black,
                child: _isLoading == true
                    ? SpinKitPulse(
                        size: 30,
                        color: Colors.white,
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              weight =
                                  double.parse(weightController.text.trim());
                            });

                            if (weight <= 0) {
                              _showMsg('Weight must be greater than 0.');
                            } else {
                              saveWeight();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'save',
                            style: universalTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading;
  int weight;
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                child: TextFormField(
                  controller: weightController,
                  obscureText: true,
                  validator: (value) => value.length < 8
                      ? 'Password must contain at least 8 characters.'
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
                          //Action what should happened when button is clicked
                          // if (_formKey.currentState.validate()) {
                          //   _login();
                          // }
                          Navigator.popAndPushNamed(context, '/homepage');
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

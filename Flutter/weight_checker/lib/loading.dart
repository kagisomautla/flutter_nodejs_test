import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 200),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/img/logo_black.jpg'),
                )),
              ),
              SizedBox(height: 20),
              Container(
                child: SpinKitThreeBounce(
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

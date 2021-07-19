import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_checker/model/api_services.dart';
import 'package:weight_checker/model/weight_model.dart';

import '../constants.dart';
import '../nav_drawer.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    //addProduct();
    super.initState();
    getWeight();
  }

  bool isDoneLoading;
  int user_id;
  List<Weight> weightList = [];
  void getWeight() async {
    setState(() {
      isDoneLoading = false;
    });
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      setState(() {
        user_id = localStorage.getInt('user_id');
      });

      final String _url = '/get_weight/$user_id';
      final response = await Api().getData(_url);
      dynamic body = json.decode(response.body);

      for (var data in body) {
        weightList.add(
          new Weight(
            data['id'],
            data['weight'],
            data['created_on'],
          ),
        );
      }

      weightList.forEach((e) {
        print('Weight: ${e.getWeight} \nDate: ${e.getDateCreatedOn}');
      });
      print(
          'Process complete.-----------------------------------------------------------------------------------');
      print(weightList.length);
      setState(() {
        isDoneLoading = true;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void deleteWeight(int weightID) async {
    setState(() {
      isDoneLoading = false;
    });
    try {
      final String _url = '/delete_weight/$weightID';
      final response = await Api().deleteData(_url);
      dynamic body = json.decode(response.body);

      if (body['status'] == "success") {
        _showMsg("Weight successfully deleted.");
      } else {
        _showMsg("Weight failed to delete.");
      }
      setState(() {
        isDoneLoading = true;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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

  void _showDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Weight",
            style: universalTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: new Text(
            "Are you sure you want to delete weight?",
            style: universalTextStyle.copyWith(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //If yes, user is logged out of the app. See logout function
                deleteWeight(id);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/historypage');
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                ),
                child: Center(
                  child: Text(
                    'Yes',
                    style: universalTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                ),
                child: Center(
                  child: Text(
                    'No',
                    style: universalTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My History',
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
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: weightList.length,
            itemBuilder: (context, index) {
              weightList[index].setDateCreatedOn();
              return Container(
                child: isDoneLoading == false
                    ? Center(
                        child: SpinKitChasingDots(
                          size: 30,
                          color: Colors.black,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          border: Border.all(color: Colors.grey[300], width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Weight:',
                                  style: universalTextStyle.copyWith(),
                                ),
                                Text('${weightList[index].weight}',
                                    style: universalTextStyle.copyWith()),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Date created:',
                                  style: universalTextStyle.copyWith(),
                                ),
                                Text(
                                  '${weightList[index].createdOn}',
                                  style: universalTextStyle.copyWith(),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    _showDialog(weightList[index].getWeightId);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

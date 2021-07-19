import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  _header() => {
        'Content-type': 'application/json',
        'Application': 'application/json',
      };

  final String _url = "http://192.168.8.110:3000";
  //post data to server
  postData(data, route) async {
    String _fullApi = _url + route;

    var response = await http.post(
      _fullApi,
      body: json.encode(data),
      headers: _header(),
    );

    return response;
  }

  //post data to server
  updateData(data, route) async {
    String _fullApi = _url + route;

    var response = await http.put(
      _fullApi,
      body: json.encode(data),
      headers: _header(),
    );
    return response;
  }

  //get data from server
  getData(route) async {
    String _fullApi = _url + route;
    var response = await http.get(
      _fullApi,
      headers: _header(),
    );
    return response;
  }

  deleteData(route) async {
    String _fullApi = _url + route;
    var response = await http.delete(
      _fullApi,
      headers: _header(),
    );
    return response;
  }
}

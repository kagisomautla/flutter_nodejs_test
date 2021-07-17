import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  _header() => {
        'Content-type': 'application/json',
        'Application': 'application/json',
      };

  final String _url = "https://127.0.0.1:3000";
  //post data to server
  postData(data, apiUrl) async {
    String _fullApi = _url + apiUrl;

    var response = await http.post(
      _fullApi,
      body: json.encode(data),
      headers: _header(),
    );

    return response;
  }

  //post data to server
  updateData(data, apiUrl) async {
    String _fullApi = _url + apiUrl;

    var response = await http.put(
      _fullApi,
      body: json.encode(data),
      headers: _header(),
    );
    return response;
  }

  //get data from server
  getData(apiUrl) async {
    String _fullApi = _url + apiUrl;
    var response = await http.get(
      _fullApi,
      headers: _header(),
    );
    return response;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Response.dart';
import 'Config.dart';
import 'MyConst.dart';

class Requester {

  Future<Response<T>> create<T>(String parentUrl, Map<String, dynamic> body, dataKey,
      Function(dynamic) encoder) async {

    var userToken = (await SharedPreferences.getInstance()).getString(MyConst.user_token_key);

    final response = await http.post(
      Uri.parse(Config.apiUrl + parentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      return Response(success: false, message: "401", data: null);
    }

    if (response.body == null) {
      return Response(success: false, message: "401", data: null);
    }

    return Response.fromJson(
      json.decode(response.body),
      dataKey,
      (data) => encoder(data));
  }


  Future<Response<T>> get<T>(String parentUrl, Map<String, dynamic> body, dataKey,
      Function(dynamic) encoder) async {

    var userToken = (await SharedPreferences.getInstance()).getString(MyConst.user_token_key);

    parentUrl += "?";

    int i = 0;
    body.forEach((key, value) {
      parentUrl += key + '=' + value;
      if (i != body.length - 1) {
        parentUrl += '&';
      }
      i++;
    });

    final response = await http.get(
        Uri.parse(Config.apiUrl + parentUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        }
    );

    if (response.statusCode == 401) {
      return Response(success: false, message: "401", data: null);
    }

    if (response.body == null) {
      return Response(success: false, message: "401", data: null);
    }

    return Response.fromJson(
        json.decode(response.body),
        dataKey,
            (data) => encoder(data));
  }

}

class RequestData<T> {
  final String error;
  final T data;

  RequestData({required this.error, required this.data});
}

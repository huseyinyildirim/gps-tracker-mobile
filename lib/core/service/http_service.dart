//region Core
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//endregion

//region Dependencies
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/service/base_service.dart';
//endregion

//region Page
//endregion

//region Widgets
//endregion

//region Models
//endregion

class HttpService extends BaseService{
// next three lines makes this class a Singleton
  static HttpService _instance = new HttpService.internal();
  HttpService.internal();
  factory HttpService() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String accessToken, String deviceId, String token, String url) async {
    return http.get(url,
        headers: <String, String>{
          //HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
          'X-DEVICE-ID': deviceId,
          'X-TOKEN': token
        }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String accessToken, String deviceId, String token, String url, {Map headers, body, encoding}) async {
    return http.post(url,
        body: body,
        headers: <String, String>{
          //HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
          'X-DEVICE-ID': deviceId,
          'X-TOKEN': token
        },
        encoding: encoding).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}
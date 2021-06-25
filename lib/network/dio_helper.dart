import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Diohelper {
  static Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    @required String url,
    Map<String, dynamic> queries,
    String lang,
    String token,
  }) async {
    dio.options.headers = {
      'lang': lang = 'en',
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.get(
      url,
      queryParameters: queries ?? null,
    );
  }

  static Future<Response> postData({
    @required String url,
    Map<String, dynamic> queries,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    return await dio.post(
      url,
      queryParameters: queries,
      data: data,
    );
  }

  static Future<Response> putData({
    @required String url,
    Map<String, dynamic> queries,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    return await dio.put(
      url,
      queryParameters: queries,
      data: data,
    );
  }
}

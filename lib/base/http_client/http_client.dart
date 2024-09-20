import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

// HTTP client for use with the main backend API.
class HttpClient with DioMixin implements Dio {

  static const String baseUrl = 'https://pixabay.com/';
  static const String apiToken = '46074580-4e519b997b66d4473e891564f';
  static const String type = 'application/json; charset=UTF-8';

  final appHeaders = {
    'Content-Type': type,
  };

  HttpClient() {
    options = BaseOptions(
        baseUrl: baseUrl,
        headers: appHeaders,
        queryParameters: {'key': apiToken, 'image_type': 'photo'}
    );
    httpClientAdapter = IOHttpClientAdapter();
  }



  final logInterceptor = LogInterceptor(
    request: false,
    requestHeader: false,
    requestBody: false,
    responseHeader: false,
    responseBody: false,
    error: true,
    logPrint: (object) => log(
      object.toString(),
      time: DateTime.now(),
      name: 'ApiHttpClient',
    ),
  );

  void configureInterceptors() {
    interceptors.addAll([
      logInterceptor,
    ]);
  }


  // Fetch images from server
  Future<Map<String, dynamic>> getImageData(Map<String, dynamic> qParameters) async {

     options.queryParameters.addAll(qParameters);

    try {
      final response = await get(
        'api/',
      );

      if(response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error! Failed to load image list.');
      }
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
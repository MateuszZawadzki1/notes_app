import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio();

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['apikey'] = dotenv.get("API_KEY");
    dio.options.headers['Authorization'] =
        'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}';

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class DioModule {
  @singleton
  Dio dioClient() {
    final dio = Dio();

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['apikey'] = dotenv.get('API_KEY');
    dio.options.headers['Authorization'] =
        'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}';
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    return dio;
  }
}

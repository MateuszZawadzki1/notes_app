import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/di.config.dart';
import 'package:notes_app/di_modules.dart';
import 'package:notes_app/network/api_service.dart';
import 'package:notes_app/network/dio_client.dart';

final getIt = GetIt.instance;

// void registerDependencies() {
//   getIt.registerFactory<ApiService>(() {
//     final dioProvider = getIt<DioProvider>();
//     final url = dotenv.get("REST_URL");
//     return ApiService(dioProvider, baseUrl: url);
//   });
// }

@InjectableInit()
Future<void> configureDependecies() async {
  getIt.init();
  //getIt.registerLazySingleton<Dio>(() => dioClient());
}

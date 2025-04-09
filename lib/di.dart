import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/di.config.dart';

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

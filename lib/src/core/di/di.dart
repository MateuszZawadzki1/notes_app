import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/core/di/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependecies() async {
  getIt.init();
  await getIt.allReady();
}

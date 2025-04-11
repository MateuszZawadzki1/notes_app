import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @Named('baseUrl')
  @singleton
  String get baseUrl => dotenv.get('REST_URL');
}

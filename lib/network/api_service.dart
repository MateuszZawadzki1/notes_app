import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/network/dio_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:notes_app/models/note.dart';

part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio, {@Named("baseUrl") String? baseUrl}) {
    return _ApiService(dio, baseUrl: baseUrl);
  }

  @GET('/all_notes')
  Future<List<Note>> getNotes();

  @POST('/notes')
  Future<void> addNote(@Body() Map<String, String> text);

  @DELETE('/notes')
  Future<void> deleteNote(@Query('id') String query);
}

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:notes_app/models/note.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET('/all_notes')
  Future<List<Note>> getNotes();
}

import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/features/notes/data/models/note.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class HiveService {
  static const String notesBoxName = 'notesBox';
  static bool _isInitialized = false;

  // Automatically init
  @postConstruct
  Future<void> init() async {
    if (_isInitialized) {
      log('HiveService juz zainicjalizowany');
      return;
    }

    log('Inicjalizacja HiveService');
    _isInitialized = true;

    final appDocumentDir = await getApplicationCacheDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }

    final box = await Hive.openBox<Note>(notesBoxName);
    log('Zawartosc hive przy starcie: ${box.values.map((n) => n.text).toList()}');
  }

  Box<Note> getNotesBox() {
    return Hive.box<Note>(notesBoxName);
  }
}

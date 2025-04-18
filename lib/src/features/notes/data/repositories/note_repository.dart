import 'dart:developer';

import 'package:dartz/dartz.dart' as dartz;
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/core/hive/hive_service.dart';
import 'package:notes_app/src/core/services/api_service.dart';
import 'package:notes_app/src/core/services/connectivity_service.dart';
import 'package:notes_app/src/features/notes/data/models/note.dart';

@injectable
class NoteRepository {
  NoteRepository(
    this._apiService,
    this._hiveService,
    this._connectivityService,
  );
  late final ApiService _apiService;
  final HiveService _hiveService;
  final ConnectivityService _connectivityService;

  Future<Either<String, List<Note>>> getNotesFromLocal() async {
    try {
      final box = _hiveService.getNotesBox();
      final notes = box.values.toList();
      return Right(notes);
    } catch (e) {
      return Left('Failed to fetch local notes: $e');
    }
  }

  Future<Either<String, dartz.Unit>> addNoteToLocal(String text) async {
    try {
      final box = _hiveService.getNotesBox();
      final now = DateTime.now().millisecondsSinceEpoch;
      final exists = box.values.any((note) =>
          note.text == text &&
          note.needsSync &&
          (note.id?.abs() ?? 0) > (now - 1000));
      if (exists) {
        log('Notatka juz istnieje w Hive: $text');
        return const Right(dartz.unit);
      }
      final note = Note(
        author: 'User',
        text: text,
        id: -now,
        needsSync: true,
      );
      await box.put(note.id.toString(), note);
      log('Zapisano notatke lokalnie ${note.text}, id: ${note.id}');
      return const Right(dartz.unit);
    } catch (e) {
      log('Blad zapisu lokalnego: $e');
      return Left('Failed to add into local base: $e');
    }
  }

  Future<Either<String, dartz.Unit>> deleteNoteFromLocal(int noteId) async {
    try {
      final box = _hiveService.getNotesBox();
      final noteKeyToDelete = box.keys.firstWhere(
        (key) => box.get(key)?.id == noteId,
        orElse: () => -1,
      );

      if (noteKeyToDelete != -1) {
        await box.delete(noteKeyToDelete);
        return const Right(dartz.unit);
      } else {
        return const Left('Not found note in local base');
      }
    } catch (e) {
      return Left('Faile to delete note: $e');
    }
  }

  Future<void> synchronizeLocalWithRemote(List<Note> remoteNotes) async {
    final box = _hiveService.getNotesBox();
    final localNotes = box.values.toList();
    final syncedNotes = <Note>[];

    for (final remoteNote in remoteNotes) {
      if (!localNotes.any((local) => local.id == remoteNote.id)) {
        syncedNotes.add(remoteNote);
      }
    }

    syncedNotes.addAll(localNotes);

    await box.clear();
    for (final note in syncedNotes) {
      await box.put(note.id.toString(), note);
    }
  }

  Future<Either<String, List<Note>>> getAllNotes() async {
    final isConnected = await _connectivityService.isConnected();

    if (isConnected) {
      try {
        final notes = await _apiService.getNotes();
        await synchronizeLocalWithRemote(notes);
        return Right(notes);
      } catch (e) {
        return getNotesFromLocal();
      }
    } else {
      return getNotesFromLocal();
    }
  }

  Future<Either<String, dartz.Unit>> addNote(String text) async {
    final isConnected = await _connectivityService.isConnected();
    if (isConnected) {
      try {
        final noteData = <String, String>{'text': text};
        await _apiService.addNote(noteData);

        final notes = await _apiService.getNotes();
        await synchronizeLocalWithRemote(notes);

        return const Right(dartz.unit);
      } catch (e) {
        return addNoteToLocal(text);
      }
    } else {
      return addNoteToLocal(text);
    }
  }

  Future<Either<String, dartz.Unit>> deleteNote(int noteId) async {
    final isConnected = await _connectivityService.isConnected();

    if (isConnected) {
      try {
        await _apiService.deleteNote('eq.$noteId');
        await deleteNoteFromLocal(noteId);

        return const Right(dartz.unit);
      } catch (e) {
        return deleteNoteFromLocal(noteId);
      }
    } else {
      return deleteNoteFromLocal(noteId);
    }
  }

  Future<Either<String, dartz.Unit>> synchronize() async {
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      return const Left('No internet connection');
    }

    try {
      final box = _hiveService.getNotesBox();
      final localNotes = box.values.where((note) => note.needsSync).toList();
      log('Notatki do synchronizacji: ${localNotes.map((n) => n.text).toList()}');

      final uniqueLocalNotes = localNotes
          .fold<Map<String, Note>>(
            {},
            (map, note) => map..[note.text + (note.author ?? '')] = note,
          )
          .values
          .toList();

      for (final note in uniqueLocalNotes) {
        final noteData = <String, String>{'text': note.text};
        await _apiService.addNote(noteData);
        final key = box.keys.firstWhere((k) => box.get(k)?.id == note.id);
        await box.delete(key);
        log('Usunięto zsynchronizowaną notatkę: ${note.text}, id: ${note.id}');
      }

      final remoteNotes = await _apiService.getNotes();
      log('Pobrano notatki z Supabase: ${remoteNotes.map((n) => n.text).toList()}');

      await box.clear();
      for (final note in remoteNotes) {
        await box.put(
          note.id.toString(),
          Note(
            text: note.text,
            id: note.id,
            author: note.author,
            needsSync: false,
          ),
        );
      }

      return const Right(dartz.unit);
    } catch (e) {
      log('Błąd synchronizacji: $e');
      return Left('Error synchronized: $e');
    }
  }
}

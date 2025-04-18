import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/core/services/connectivity_service.dart';
import 'package:notes_app/src/features/notes/data/models/note.dart';
import 'package:notes_app/src/features/notes/data/repositories/note_repository.dart';

part 'notes_state.dart';

@singleton
class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this.noteRepository, this.connectivityService)
      : super(NotesInitial()) {
    _initialize();
  }

  final NoteRepository noteRepository;
  final ConnectivityService connectivityService;
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _isInitialized = false;
  bool _isSynchronizing = false; // synchronize control
  int _fetchNotesCallCount = 0;

  Future<void> _initialize() async {
    if (_isInitialized) {
      log('NotesCubit już zainicjalizowany, pomijam init');
      return;
    }
    _isInitialized = true;
    log('Inicjalizacja NotesCubit');

    _subscription = connectivityService.connectivityStream.distinct().listen(
      (result) {
        log('Zmiana stanu połączenia: $result');
        if (result != ConnectivityResult.none && !_isSynchronizing) {
          log('Wywoluje synchornize z connectivityStream');
          synchronize();
        }
      },
      onError: (e) => log('Blad w connectivityStream: $e'),
    );

    await fetchNotes();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> fetchNotes() async {
    _fetchNotesCallCount++;
    emit(NotesLoading());
    final isConnected = await connectivityService.isConnected();
    final notes = await noteRepository.getAllNotes();
    log('Wczytano notatki: ${notes.fold((l) => l, (r) => r.map((n) => n.text).toList())}');
    notes.fold(
      (error) => emit(NotesError(message: error)),
      (result) {
        log('Wczytane notatki: ${result.map((n) => n.text).toList()}');
        emit(
          NotesLoaded(
            notes: result
                .where((note) => note.text.isNotEmpty && note.id != null)
                .toList(),
            isOffline: !isConnected,
          ),
        );
      },
    );
  }

  Future<void> addNote(String text) async {
    emit(NotesLoading());
    final result = await noteRepository.addNote(text);
    result.fold((error) => emit(NotesError(message: error)), (_) {
      log('Dodano notatkę: $text, wywołuję fetchNotes');
      fetchNotes();
    });
  }

  Future<void> deleteNote(int noteId) async {
    emit(NotesLoading());
    final result = await noteRepository.deleteNote(noteId);
    result.fold(
      (error) => emit(NotesError(message: error)),
      (_) => fetchNotes(),
    );
  }

  Future<void> synchronize() async {
    if (_isSynchronizing) {
      log('Synchronizacja już w toku, pomijam');
      return;
    }
    _isSynchronizing = true;
    log('Rozpoczęto synchronizację');
    emit(NotesLoading());
    final result = await noteRepository.synchronize();
    result.fold(
      (error) => emit(NotesError(message: error)),
      (_) {
        log('Zakończono synchronizację, wywołuję fetchNotes');
        fetchNotes();
      },
    );
    _isSynchronizing = false;
  }
}

part of 'notes_cubit.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  const NotesLoaded({required this.notes, this.isOffline = false});
  final List<Note> notes;
  final bool isOffline;

  @override
  List<Object> get props => [notes, isOffline];
}

final class NotesError extends NotesState {
  const NotesError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

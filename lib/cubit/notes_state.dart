part of 'notes_cubit.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<Note> notes;
  const NotesLoaded({required this.notes});
}

final class NotesError extends NotesState {
  final String message;
  const NotesError({required this.message});
}

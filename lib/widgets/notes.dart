import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes_app/blocs/auth/auth_bloc.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/blocs/auth/auth_state.dart';
import 'package:notes_app/cubit/notes_cubit.dart';
import 'package:notes_app/di.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/widgets/note_list/note_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes_app/l10n_extension.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NotesCubit>()..fetchNotes(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckStatus()),
        ),
      ],
      child: NotesScreen(),
    );
  }
}

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        title: Text(context.l10n.notes,
            style: const TextStyle(color: Colors.blue)),
        leading: PopupMenuButton<String>(
          color: Colors.white,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "Log out",
              child: Row(
                children: [
                  const Icon(Icons.logout_outlined),
                  Text(context.l10n.logout),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.menu, color: Colors.blue),
          onSelected: (value) async {
            if (value == "Log out") {
              context.read<AuthBloc>().add(AuthLogutRequested());
            }
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          log('message');
          if (state is AuthUnauthenticated) {
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(
                '/login',
              );
            }
          }
        },
        child: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: NoteList(
                      notes: state.notes,
                      onDelete: (id) =>
                          context.read<NotesCubit>().deleteNote(id),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () => _dialogBuilderNewNote(context),
                            icon: const Icon(Icons.add,
                                size: 40, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is NotesError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<void> _dialogBuilderNewNote(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.95,
            height: MediaQuery.of(dialogContext).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.addNote,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: context.l10n.enterNote,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(context.l10n.cancel,
                          style: const TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_noteController.text.isNotEmpty) {
                          context
                              .read<NotesCubit>()
                              .addNote(_noteController.text);
                          Navigator.of(dialogContext).pop();
                        } else {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                                content: Text('Note cannot be empty')),
                          );
                        }
                      },
                      child: Text(context.l10n.add,
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

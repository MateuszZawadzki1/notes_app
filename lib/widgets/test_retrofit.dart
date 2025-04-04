import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/network/api_service.dart';
import 'package:notes_app/network/dio_client.dart';
import 'package:notes_app/repositories/note_repository.dart';

class TestRetrofit extends StatefulWidget {
  @override
  _TestRetrofitState createState() => _TestRetrofitState();
}

class _TestRetrofitState extends State<TestRetrofit> {
  late NoteRepository noteRepository;
  late Future<List<Note>> allNotes;

  @override
  void initState() {
    super.initState();
    noteRepository = NoteRepository();
    allNotes = noteRepository.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notes"),
      ),
      body: FutureBuilder<List<Note>>(
          future: allNotes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return Center(
                child: Text(jsonEncode(
                    snapshot.data!.map((note) => note.toJson()).toList())),
              );
            } else {
              return const Center(
                child: Text("Not avaible"),
              );
            }
          }),
    );
  }
}

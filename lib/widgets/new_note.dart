import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() {
    return _NewNote();
  }
}

class _NewNote extends State<NewNote> {
  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

Future<void> _dialogBuilderNewNote(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog();
    },
  );
}

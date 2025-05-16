// lib/screens/notes_screen.dart

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note_model.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

// Cinematic palette
const kBgColor     = Color(0xFF0B132B); // Midnight Navy
const kCardColor   = Color(0xFF1C2541); // Space Cadet
const kAccentColor = Color(0xFFFCA311); // Amber Gold

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Future<List<NoteModel>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = DatabaseHelper.instance.getAllNotes();
  }

  void _refresh() {
    setState(() {
      _notesFuture = DatabaseHelper.instance.getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: kCardColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: _notesFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error: ${snap.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          final notes = snap.data ?? [];
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No notes yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final n = notes[i];
              return NoteCard(
                note: n,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteEditorScreen(note: n),
                  ),
                ).then((_) => _refresh()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(Icons.add, color: Colors.black87),
        onPressed: () async {
          // Open NoteEditorScreen with no initial note (create new)
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
          );
          // Refresh list after return
          _refresh();
        },
      ),
    );
  }
}

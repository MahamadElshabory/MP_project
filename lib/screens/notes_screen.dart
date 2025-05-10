import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note_model.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

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
    _loadNotes();
  }

  void _loadNotes() {
    setState(() {
      _notesFuture = DatabaseHelper.instance.getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: FutureBuilder<List<NoteModel>>(
        future: _notesFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final notes = snap.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet.\nTap + to add one.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final note = notes[i];
              return NoteCard(
                note: note,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteEditorScreen(note: note),
                  ),
                ).then((_) => _loadNotes()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
        ).then((_) => _loadNotes()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

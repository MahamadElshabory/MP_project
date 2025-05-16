import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note_model.dart';

// Cinematic palette
const kBgColor     = Color(0xFF0B132B); // Midnight Navy
const kCardColor   = Color(0xFF1C2541); // Space Cadet
const kAccentColor = Color(0xFFFCA311); // Amber Gold

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;
  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _timestamp;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _titleController = TextEditingController(text: n?.title ?? '');
    _contentController = TextEditingController(text: n?.content ?? '');
    _timestamp = n?.timestamp ?? DateTime.now();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    final title   = _titleController.text.trim();
    final content = _contentController.text.trim();
    final db      = DatabaseHelper.instance;

    if (widget.note == null) {
      await db.createNote(
        NoteModel(
          title:     title,
          content:   content,
          timestamp: _timestamp,
        ),
      );
    } else {
      final updated = widget.note!.copyWith(
        title:     title,
        content:   content,
        timestamp: _timestamp,
      );
      await db.updateNote(updated);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        backgroundColor: kCardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: kAccentColor),
            onPressed: _saveNote,
            tooltip: 'Save note',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: kCardColor,
                  prefixIcon: const Icon(Icons.title, color: kAccentColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // Content field
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: const TextStyle(color: Colors.white70),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: kCardColor,
                    prefixIcon:
                    const Icon(Icons.note, color: kAccentColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: null,
                  expands: true,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

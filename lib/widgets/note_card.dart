import 'package:flutter/material.dart';
import '../models/note_model.dart';

const kCardColor   = Color(0xFF355B73);
const kAccentColor = Color(0xFF2196F3);

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;

  const NoteCard({
    Key? key,
    required this.note,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(Icons.description, color: kAccentColor),
        title: Text(
          note.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          note.timestamp.toLocal().toString().substring(0, 16),
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      ),
    );
  }
}

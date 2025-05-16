import 'package:flutter/material.dart';
import '../models/class_model.dart';

const kBackgroundColor = Color(0xFF0A1931);
const kCardColor       = Color(0xFF0F3057);
const kAccentColor     = Color(0xFF1B4965);

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({Key? key, required this.classModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = classModel;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(c.courseName),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoTile(icon: Icons.meeting_room, label: 'Room', value: c.roomNumber),
            const SizedBox(height: 12),
            _infoTile(icon: Icons.person,       label: 'Professor', value: c.professor),
            const SizedBox(height: 12),
            _infoTile(icon: Icons.link,         label: 'Materials', value: c.materials),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: kAccentColor),
        title: Text(
          '$label:',
          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : '—',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

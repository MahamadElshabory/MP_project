import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../models/group_note_model.dart';
import '../models/assignment_model.dart';
import '../models/session_model.dart';
import '../services/firebase_service.dart';

const kBgColor     = Color(0xFF0A1F44);
const kCardColor   = Color(0xFF1E2A56);
const kAccentColor = Color(0xFF4A90E2);

class GroupDetailScreen extends StatefulWidget {
  final EventModel group;
  const GroupDetailScreen({Key? key, required this.group})
      : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final _noteCtrl     = TextEditingController();
  final _assignTitle  = TextEditingController();
  DateTime? _assignDue;
  final _sessionTitle = TextEditingController();
  DateTime? _sessionTime;

  @override
  void dispose() {
    _noteCtrl.dispose();
    _assignTitle.dispose();
    _sessionTitle.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final text = _noteCtrl.text.trim();
    if (text.isEmpty) return;
    await FirebaseService.instance
        .postGroupNote(widget.group.firebaseKey!, text);
    _noteCtrl.clear();
  }

  Future<void> _showAddAssignmentDialog() async {
    _assignTitle.clear();
    _assignDue = null;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardColor,
        title: const Text('New Assignment', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _assignTitle,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _assignDue == null
                        ? 'No due date'
                        : _assignDue!.toLocal().toString().substring(0, 16),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  child: const Text('Pick Date'),
                  style: TextButton.styleFrom(foregroundColor: kAccentColor),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (_, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: kAccentColor,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (d != null) setState(() => _assignDue = d);
                  },
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kAccentColor),
            onPressed: () {
              final title = _assignTitle.text.trim();
              if (title.isEmpty || _assignDue == null) return;
              final a = AssignmentModel(
                key: '',
                title: title,
                dueDate: _assignDue!,
              );
              FirebaseService.instance
                  .postGroupAssignment(widget.group.firebaseKey!, a);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSessionDialog() async {
    _sessionTitle.clear();
    _sessionTime = null;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardColor,
        title: const Text('Schedule Session', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _sessionTitle,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _sessionTime == null
                        ? 'No time'
                        : _sessionTime!.toLocal().toString().substring(0, 16),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  child: const Text('Pick'),
                  style: TextButton.styleFrom(foregroundColor: kAccentColor),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (_, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: kAccentColor,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (d == null) return;
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    );
                    if (t == null) return;
                    setState(() {
                      _sessionTime = DateTime(
                        d.year,
                        d.month,
                        d.day,
                        t.hour,
                        t.minute,
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kAccentColor),
            onPressed: () {
              final title = _sessionTitle.text.trim();
              if (title.isEmpty || _sessionTime == null) return;
              final s = SessionModel(
                key: '',
                title: title,
                sessionTime: _sessionTime!,
              );
              FirebaseService.instance
                  .postGroupSession(widget.group.firebaseKey!, s);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fb       = FirebaseService.instance;
    final groupKey = widget.group.firebaseKey!;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(widget.group.title),
        backgroundColor: kBgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.group.description,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const Divider(color: Colors.white24),

            // Notes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Notes',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 140,
              child: StreamBuilder<List<GroupNoteModel>>(
                stream: fb.groupNotesStream(groupKey),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator(color: kAccentColor));
                  }
                  final notes = snap.data!;
                  if (notes.isEmpty) {
                    return const Center(
                      child: Text('No notes yet.', style: TextStyle(color: Colors.white54)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notes.length,
                    itemBuilder: (ctx, i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(notes[i].content, style: const TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'New note',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: kCardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, size: 24),
                    color: kAccentColor,
                    onPressed: _addNote,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),

            // Assignments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Assignments',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 140,
              child: StreamBuilder<List<AssignmentModel>>(
                stream: fb.groupAssignmentsStream(groupKey),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator(color: kAccentColor));
                  }
                  final list = snap.data!;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('No assignments.', style: TextStyle(color: Colors.white54)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final a = list[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                        tileColor: kCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(a.title, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          a.dueDate.toLocal().toString().substring(0, 16),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kAccentColor),
                icon: const Icon(Icons.assignment, color: Colors.white),
                label: const Text('Add Assignment'),
                onPressed: _showAddAssignmentDialog,
              ),
            ),
            const Divider(color: Colors.white24),

            // Sessions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Sessions',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 140,
              child: StreamBuilder<List<SessionModel>>(
                stream: fb.groupSessionsStream(groupKey),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator(color: kAccentColor));
                  }
                  final list = snap.data!;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('No sessions.', style: TextStyle(color: Colors.white54)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final s = list[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                        tileColor: kCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(s.title, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          s.sessionTime.toLocal().toString().substring(0, 16),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kAccentColor),
                icon: const Icon(Icons.schedule, color: Colors.white),
                label: const Text('Schedule Session'),
                onPressed: _showAddSessionDialog,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/event_model.dart';
import '../widgets/group_card.dart';
import 'create_group_screen.dart';

class StudyGroupScreen extends StatefulWidget {
  const StudyGroupScreen({Key? key}) : super(key: key);

  @override
  State<StudyGroupScreen> createState() => _StudyGroupScreenState();
}

class _StudyGroupScreenState extends State<StudyGroupScreen> {
  late Future<List<EventModel>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    setState(() {
      _groupsFuture = DatabaseHelper.instance
          .getAllEvents()
          .then((all) =>
          all.where((e) => e.category == 'study_group').toList());
    });
  }

  Future<void> _toggleRSVP(EventModel group) async {
    final updated = group.copyWith(isRSVP: !group.isRSVP);
    await DatabaseHelper.instance.updateEvent(updated);
    _loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: FutureBuilder<List<EventModel>>(
        future: _groupsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final groups = snap.data ?? [];
          if (groups.isEmpty) {
            return const Center(
              child: Text('No study groups yet.\nTap + to create one.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, i) {
              final g = groups[i];
              return GroupCard(
                title: g.title,
                subtitle:
                '${g.dateTime.toLocal().toString().substring(0, 16)}',
                rsvped: g.isRSVP,
                onRSVP: () => _toggleRSVP(g),
                onTap: () {
                  // you could navigate to a detailed chat screen here
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
        ).then((_) => _loadGroups()),
      ),
    );
  }
}

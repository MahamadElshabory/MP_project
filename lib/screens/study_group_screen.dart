// lib/screens/study_group_screen.dart

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/event_model.dart';
import '../widgets/group_card.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';

class StudyGroupScreen extends StatelessWidget {
  const StudyGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: StreamBuilder<List<EventModel>>(
        stream: fb.groupsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final groups = snapshot.data ?? [];
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
              final formattedDate =
              g.dateTime.toLocal().toString().substring(0, 16);
              return GroupCard(
                title: g.title,
                subtitle: formattedDate,
                rsvped: g.isRSVP,
                onRSVP: () => fb.updateGroupRSVP(g.firebaseKey!, !g.isRSVP),
                onTap: () {
                  // Navigate to group detail to view/add notes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupDetailScreen(group: g),
                    ),
                  );
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
        ),
      ),
    );
  }
}

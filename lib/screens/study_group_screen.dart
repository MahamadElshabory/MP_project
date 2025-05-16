import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/event_model.dart';
import '../widgets/group_card.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';

const kBgColor     = Color(0xFF0A1F44);
const kAccentColor = Color(0xFF4A90E2);

class StudyGroupScreen extends StatelessWidget {
  const StudyGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('Study Groups'),
        backgroundColor: kBgColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: fb.groupsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final groups = snapshot.data ?? [];
          if (groups.isEmpty) {
            return const Center(
              child: Text(
                'No study groups yet.\nTap + to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
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
                onRSVP: () =>
                    fb.updateGroupRSVP(g.firebaseKey!, !g.isRSVP),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupDetailScreen(group: g),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
        ),
      ),
    );
  }
}

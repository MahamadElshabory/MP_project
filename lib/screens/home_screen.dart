// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/announcement_model.dart';
import '../widgets/calendar_view.dart';
import '../widgets/event_card.dart';
import 'create_announcement_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isTeacher;

  const HomeScreen({
    Key? key,
    required this.isTeacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;
    final greeting = isTeacher ? 'Welcome, Teacher' : 'Welcome, Student';

    return Scaffold(
      appBar: AppBar(
        title: Text(greeting),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // After signOut, AuthGate will redirect to LoginScreen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Announcements ---
            Text('Announcements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: StreamBuilder<List<AnnouncementModel>>(
                stream: fb.announcementsStream(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = snap.data!;
                  if (list.isEmpty) {
                    return const Center(child: Text('No announcements.'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final a = list[i];
                      return Card(
                        margin: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  a.content,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                              Text(
                                a.timestamp.toLocal().toIso8601String().substring(0, 16),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // --- Upcoming Events (stub) ---
            Text('Upcoming', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            EventCard(
              title: 'Math Lecture',
              subtitle: 'Today • 10:00 AM',
              rsvped: false,
              onRSVP: () {},
              onTap: () {},
            ),

            const Divider(height: 32),

            // --- Semester Calendar ---
            Text('Semester Calendar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CalendarView(),
          ],
        ),
      ),

      // Only teachers can post announcements
      floatingActionButton: isTeacher
          ? FloatingActionButton(
        child: const Icon(Icons.announcement),
        tooltip: 'New Announcement',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CreateAnnouncementScreen(),
          ),
        ),
      )
          : null,
    );
  }
}

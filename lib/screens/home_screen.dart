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
  const HomeScreen({Key? key, required this.isTeacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;
    final greeting = isTeacher ? 'Welcome, Teacher' : 'Welcome, Student';

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 1,
        title: Text(
          greeting,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async => await FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Announcements ---
              Text(
                'Announcements',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: StreamBuilder<List<AnnouncementModel>>(
                  stream: fb.announcementsStream(),
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.tealAccent),
                          backgroundColor: Colors.grey,
                        ),
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
                    final list = snap.data!;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'No announcements.',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      );
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: list.length,
                      itemBuilder: (ctx, i) {
                        final a = list[i];
                        return Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 260,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    a.content,
                                    style: TextStyle(
                                        color: Colors.grey[300], fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  a.timestamp
                                      .toLocal()
                                      .toIso8601String()
                                      .substring(0, 16),
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
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

              const SizedBox(height: 32),

              // --- Upcoming Events (stub) ---
              Text(
                'Upcoming',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              EventCard(
                title: 'Math Lecture',
                subtitle: 'Today • 10:00 AM',
                rsvped: false,
                onRSVP: () {},
                onTap: () {},
              ),

              const SizedBox(height: 32),
              const Divider(color: Colors.grey),
              const SizedBox(height: 32),

              // --- Semester Calendar ---
              Text(
                'Semester Calendar',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // give the calendar a fixed height so the scroll view can exceed the screen
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: const CalendarView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black87,
        splashColor: Colors.white24,
        tooltip: 'New Announcement',
        child: const Icon(Icons.announcement_outlined),
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

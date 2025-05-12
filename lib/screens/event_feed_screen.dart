// lib/screens/event_feed_screen.dart

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';
import 'create_event_screen.dart';

class EventFeedScreen extends StatelessWidget {
  final bool isTeacher;

  const EventFeedScreen({
    Key? key,
    required this.isTeacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Events')),
      body: StreamBuilder<List<EventModel>>(
        stream: fb.eventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, i) {
              final e = events[i];
              final formattedDate = e.dateTime
                  .toLocal()
                  .toString()
                  .substring(0, 16);
              return EventCard(
                title: e.title,
                subtitle: formattedDate,
                rsvped: e.isRSVP,
                onRSVP: () =>
                    fb.updateEventRSVP(e.firebaseKey!, !e.isRSVP),
                onTap: () {
                  // TODO: navigate to a detailed event page if desired
                },
              );
            },
          );
        },
      ),

      // Only show the FAB to teachers
      floatingActionButton: isTeacher
          ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateEventScreen(),
            ),
          );
        },
      )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';
import 'create_event_screen.dart';

const kBgColor     = Color(0xFF222240);
const kCardColor   = Color(0xFF2D2F4A);
const kAccentColor = Color(0xFFE98074);

class EventFeedScreen extends StatelessWidget {
  final bool isTeacher;
  const EventFeedScreen({Key? key, required this.isTeacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('Campus Events'),
        backgroundColor: kBgColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: fb.eventsStream(),
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
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No events found.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, i) {
              final e = events[i];
              final formatted = e.dateTime
                  .toLocal()
                  .toString()
                  .substring(0, 16);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + i * 50),
                builder: (_, opacity, child) =>
                    Opacity(opacity: opacity, child: child),
                child: EventCard(
                  title: e.title,
                  subtitle: formatted,
                  rsvped: e.isRSVP,
                  onRSVP: () =>
                      fb.updateEventRSVP(e.firebaseKey!, !e.isRSVP),
                  onTap: () {
                    // TODO: detail page
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
              const CreateEventScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      )
          : null,
    );
  }
}

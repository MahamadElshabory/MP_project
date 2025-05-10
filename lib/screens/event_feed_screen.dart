import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';

class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({Key? key}) : super(key: key);

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _eventsFuture = DatabaseHelper.instance
          .getAllEvents()
          .then((all) =>
          all.where((e) => e.category != 'study_group').toList());
    });
  }

  Future<void> _toggleRSVP(EventModel event) async {
    final updated = event.copyWith(isRSVP: !event.isRSVP);
    await DatabaseHelper.instance.updateEvent(updated);
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Events')),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
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
              final formattedDate =
                  '${e.dateTime.toLocal().toString().substring(0, 16)}';
              return EventCard(
                title: e.title,
                subtitle: formattedDate,
                rsvped: e.isRSVP,
                onRSVP: () => _toggleRSVP(e),
                onTap: () {
                  // TODO: navigate to a detailed event page
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/calendar_view.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Example “Math Lecture” card
            EventCard(
              title: 'Math Lecture',
              subtitle: 'Today • 10:00 AM',
              rsvped: false,
              onRSVP: () {
                // TODO: toggle or save RSVP state for this event
              },
              onTap: () {
                // TODO: navigate to event detail
              },
            ),

            // Example “Study Group” card
            EventCard(
              title: 'Study Group: Chemistry',
              subtitle: 'Today • 2:00 PM',
              rsvped: false,
              onRSVP: () {
                // TODO: toggle or save RSVP state for this group
              },
              onTap: () {
                // TODO: navigate to group detail
              },
            ),

            const Divider(height: 32),
            Text(
              'Semester Calendar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // CalendarView is not a const constructor
            CalendarView(),
          ],
        ),
      ),
    );
  }
}

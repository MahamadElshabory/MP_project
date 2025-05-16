// lib/widgets/calendar_view.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
      lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

      // When user taps a day
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      // Hide format button
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon:
        const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon:
        const Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle:
        const TextStyle(color: Colors.white, fontSize: 16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.grey[400]),
        weekdayStyle: TextStyle(color: Colors.grey[400]),
      ),

      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: Colors.grey[300]),
        defaultTextStyle: TextStyle(color: Colors.grey[300]),
        todayDecoration: BoxDecoration(
          color: Colors.tealAccent,
          shape: BoxShape.circle,
        ),
        todayTextStyle:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),

      calendarBuilders: CalendarBuilders(
        defaultBuilder: (ctx, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.grey[300]),
            ),
          );
        },
        todayBuilder: (ctx, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.tealAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          );
        },
        selectedBuilder: (ctx, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),

      // Dark background behind days
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.all,
      headerVisible: true,
    );
  }
}

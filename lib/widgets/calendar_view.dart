import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder box; swap with TableCalendar or similar later
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text('Calendar Widget')),
    );
  }
  const CalendarView({Key? key}) : super(key: key);
}


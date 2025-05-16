import 'package:flutter/material.dart';

const kCardColor   = Color(0xFF2D2F4A);
const kAccentColor = Color(0xFFE98074);

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool rsvped;
  final VoidCallback? onRSVP;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.rsvped = false,
    this.onRSVP,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.event, color: kAccentColor),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: Icon(
            rsvped ? Icons.check_circle : Icons.check_circle_outline,
            color: rsvped ? Colors.greenAccent : Colors.white70,
          ),
          onPressed: onRSVP,
        ),
      ),
    );
  }
}

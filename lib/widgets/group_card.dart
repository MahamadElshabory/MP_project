import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool rsvped;
  final VoidCallback onRSVP;
  final VoidCallback? onTap;

  const GroupCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.rsvped = false,
    required this.onRSVP,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: TextButton(
          onPressed: onRSVP,
          child: Text(rsvped ? 'Joined' : 'RSVP'),
        ),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ClassCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}

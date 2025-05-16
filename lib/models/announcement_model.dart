import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Your existing data model — unchanged
class AnnouncementModel {
  final String key;
  final String title;
  final String content;
  final DateTime timestamp;

  AnnouncementModel({
    required this.key,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory AnnouncementModel.fromMap(String key, Map<String, dynamic> m) {
    return AnnouncementModel(
      key: key,
      title: m['title'] as String? ?? '',
      content: m['content'] as String? ?? '',
      timestamp: DateTime.parse(m['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// A ready-to-use dark-themed card widget for your announcements
class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({Key? key, required this.announcement})
      : super(key: key);

  String _formatTimestamp(DateTime dt) {
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}   ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              announcement.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Content
            Text(
              announcement.content,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Timestamp aligned right
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTimestamp(announcement.timestamp),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// (Optional) A helper widget to build a list of AnnouncementCards
class AnnouncementList extends StatelessWidget {
  final List<AnnouncementModel> items;

  const AnnouncementList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (ctx, i) => AnnouncementCard(announcement: items[i]),
    );
  }
}

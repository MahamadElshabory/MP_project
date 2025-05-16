// lib/models/session_model.dart

class SessionModel {
  final String key;
  final String title;
  final DateTime sessionTime;

  SessionModel({
    required this.key,
    required this.title,
    required this.sessionTime,
  });

  factory SessionModel.fromMap(String key, Map<String, dynamic> m) {
    return SessionModel(
      key: key,
      title: m['title'] as String? ?? '',
      sessionTime: DateTime.parse(m['sessionTime'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'sessionTime': sessionTime.toIso8601String(),
  };
}

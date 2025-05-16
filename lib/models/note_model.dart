// lib/models/note_model.dart

class NoteModel {
  /// Local SQLite row ID
  final int? id;

  /// Firebase key under /study_groups/.../notes
  final String? firebaseKey;

  final String title;
  final String content;
  final DateTime timestamp;

  NoteModel({
    this.id,
    this.firebaseKey,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  /// For your local SQLite table 'notes'
  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
    id: map['id'] as int?,
    firebaseKey: null,
    title: map['title'] as String,
    content: map['content'] as String,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );

  /// For the Firebase side at /study_groups/<groupKey>/notes
  factory NoteModel.fromFirebase(String key, Map<String, dynamic> m) => NoteModel(
    id: null,
    firebaseKey: key,
    title: m['authorUid'] as String, // or store/display author differently
    content: m['content'] as String,
    timestamp: DateTime.parse(m['timestamp'] as String),
  );

  /// When writing into your local SQLite
  Map<String, dynamic> toMap() {
    final out = <String, dynamic>{
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
    if (id != null) out['id'] = id;
    return out;
  }

  /// When you need a copy (both locally and firebase)
  NoteModel copyWith({
    int? id,
    String? firebaseKey,
    String? title,
    String? content,
    DateTime? timestamp,
  }) {
    return NoteModel(
      id: id ?? this.id,
      firebaseKey: firebaseKey ?? this.firebaseKey,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

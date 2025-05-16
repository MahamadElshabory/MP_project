// lib/models/group_note_model.dart

class GroupNoteModel {
  /// The Firebase‐generated key for this note
  final String key;

  /// Who posted it
  final String authorUid;

  /// The text of the note
  final String content;

  /// When it was created
  final DateTime timestamp;

  GroupNoteModel({
    required this.key,
    required this.authorUid,
    required this.content,
    required this.timestamp,
  });

  /// Used by FirebaseService.groupNotesStream
  factory GroupNoteModel.fromMap(String key, Map<String, dynamic> m) {
    return GroupNoteModel(
      key: key,
      authorUid: m['authorUid'] as String? ?? '',
      content: m['content'] as String? ?? '',
      timestamp: DateTime.parse(m['timestamp'] as String),
    );
  }
}

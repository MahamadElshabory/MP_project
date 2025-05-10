class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime timestamp;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? timestamp,
  }) =>
      NoteModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
      );

  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
    id: map['id'] as int?,
    title: map['title'] as String,
    content: map['content'] as String,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
    if (id != null) m['id'] = id;
    return m;
  }
}

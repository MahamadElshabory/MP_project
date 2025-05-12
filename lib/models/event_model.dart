class EventModel {
  final String? firebaseKey;
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;   // e.g. "meeting", "deadline", "study_group"
  final bool isRSVP;       // NEW

  EventModel({
    this.firebaseKey,
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.isRSVP = false,   // default false
  });

  // Create from Firebase snapshot
  factory EventModel.fromFirebase(String key, Map<String, dynamic> m) {
    return EventModel(
      firebaseKey: key,
      title: m['title'] as String? ?? '',
      description: m['description'] as String? ?? '',
      dateTime: DateTime.parse(m['dateTime'] as String),
      category: m['category'] as String? ?? '',
      isRSVP: (m['isRSVP'] as int? ?? 0) == 1,
    );
  }

  // Convert to Firebase payload
  Map<String, dynamic> toFirebase() => {
    'title': title,
    'description': description,
    'dateTime': dateTime.toIso8601String(),
    'category': category,
    'isRSVP': isRSVP ? 1 : 0,
  };

  EventModel copyWith({
    String? firebaseKey,
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? category,
    bool? isRSVP,
  }) =>
      EventModel(
        firebaseKey: firebaseKey ?? this.firebaseKey,
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dateTime: dateTime ?? this.dateTime,
        category: category ?? this.category,
        isRSVP: isRSVP ?? this.isRSVP,
      );

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
    id: map['id'] as int?,
    title: map['title'] as String,
    description: map['description'] as String,
    dateTime: DateTime.parse(map['dateTime'] as String),
    category: map['category'] as String,
    isRSVP: (map['isRSVP'] as int) == 1,
  );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'isRSVP': isRSVP ? 1 : 0,
    };
    if (id != null) m['id'] = id;
    return m;
  }
}

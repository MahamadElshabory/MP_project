class EventModel {
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;   // e.g. "meeting", "deadline", "study_group"
  final bool isRSVP;       // NEW

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.isRSVP = false,   // default false
  });

  EventModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? category,
    bool? isRSVP,
  }) =>
      EventModel(
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

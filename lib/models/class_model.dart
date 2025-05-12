class ClassModel {
  final int? id;            // local SQLite PK
  final String key;         // Firebase key
  final String courseName;
  final String roomNumber;
  final String professor;
  final String materials;

  ClassModel({
    this.id,
    required this.key,
    required this.courseName,
    required this.roomNumber,
    required this.professor,
    required this.materials,
  });

  /// For Firebase rows: supply key & map
  factory ClassModel.fromFirebase(String key, Map<String, dynamic> m) {
    return ClassModel(
      key: key,
      courseName: m['courseName'] as String,
      roomNumber: m['roomNumber'] as String,
      professor: m['professor'] as String? ?? '',
      materials: m['materials'] as String? ?? '',
    );
  }

  /// For local DB rows: map includes `id` and we inject `key` = '' if none
  factory ClassModel.fromMap(Map<String, dynamic> m) {
    return ClassModel(
      id: m['id'] as int?,
      key: m['key'] as String? ?? '',
      courseName: m['courseName'] as String,
      roomNumber: m['roomNumber'] as String,
      professor: m['professor'] as String? ?? '',
      materials: m['materials'] as String? ?? '',
    );
  }

  ClassModel copyWith({
    int? id,
    String? key,
    String? courseName,
    String? roomNumber,
    String? professor,
    String? materials,
  }) {
    return ClassModel(
      id: id ?? this.id,
      key: key ?? this.key,
      courseName: courseName ?? this.courseName,
      roomNumber: roomNumber ?? this.roomNumber,
      professor: professor ?? this.professor,
      materials: materials ?? this.materials,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'roomNumber': roomNumber,
      'professor': professor,
      'materials': materials,
    };
  }
}

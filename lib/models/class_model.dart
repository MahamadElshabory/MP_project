class ClassModel {
  final int? id;
  final String courseName;
  final String room;
  final String professor;
  final String day;
  final String startTime;
  final String endTime;

  ClassModel({
    this.id,
    required this.courseName,
    required this.room,
    required this.professor,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  ClassModel copyWith({
    int? id,
    String? courseName,
    String? room,
    String? professor,
    String? day,
    String? startTime,
    String? endTime,
  }) =>
      ClassModel(
        id: id ?? this.id,
        courseName: courseName ?? this.courseName,
        room: room ?? this.room,
        professor: professor ?? this.professor,
        day: day ?? this.day,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  factory ClassModel.fromMap(Map<String, dynamic> map) => ClassModel(
    id: map['id'] as int?,
    courseName: map['courseName'] as String,
    room: map['room'] as String,
    professor: map['professor'] as String,
    day: map['day'] as String,
    startTime: map['startTime'] as String,
    endTime: map['endTime'] as String,
  );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'courseName': courseName,
      'room': room,
      'professor': professor,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
    if (id != null) m['id'] = id;
    return m;
  }
}

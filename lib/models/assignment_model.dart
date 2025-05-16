// lib/models/assignment_model.dart

class AssignmentModel {
  final String key;
  final String title;
  final DateTime dueDate;

  AssignmentModel({
    required this.key,
    required this.title,
    required this.dueDate,
  });

  factory AssignmentModel.fromMap(String key, Map<String, dynamic> m) {
    return AssignmentModel(
      key: key,
      title: m['title'] as String? ?? '',
      dueDate: DateTime.parse(m['dueDate'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'dueDate': dueDate.toIso8601String(),
  };
}

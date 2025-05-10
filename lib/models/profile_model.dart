class ProfileModel {
  final int id;
  final String name;
  final bool notificationsEnabled;
  final bool syncEnabled;

  ProfileModel({
    required this.id,
    required this.name,
    required this.notificationsEnabled,
    required this.syncEnabled,
  });

  ProfileModel copyWith({
    int? id,
    String? name,
    bool? notificationsEnabled,
    bool? syncEnabled,
  }) =>
      ProfileModel(
        id: id ?? this.id,
        name: name ?? this.name,
        notificationsEnabled:
        notificationsEnabled ?? this.notificationsEnabled,
        syncEnabled: syncEnabled ?? this.syncEnabled,
      );

  factory ProfileModel.fromMap(Map<String, dynamic> m) => ProfileModel(
    id: m['id'] as int,
    name: m['name'] as String,
    notificationsEnabled: (m['notificationsEnabled'] as int) == 1,
    syncEnabled: (m['syncEnabled'] as int) == 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'notificationsEnabled': notificationsEnabled ? 1 : 0,
    'syncEnabled': syncEnabled ? 1 : 0,
  };
}

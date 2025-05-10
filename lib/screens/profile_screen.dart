import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileModel _profile;
  bool _loading = true;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await DatabaseHelper.instance.getProfile();
    _nameController = TextEditingController(text: p.name);
    setState(() {
      _profile = p;
      _loading = false;
    });
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;
    final updated = _profile.copyWith(name: newName);
    await DatabaseHelper.instance.updateProfile(updated);
    setState(() => _profile = updated);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Name saved')));
  }

  Future<void> _toggleNotifications(bool enabled) async {
    final updated = _profile.copyWith(notificationsEnabled: enabled);
    await DatabaseHelper.instance.updateProfile(updated);
    setState(() => _profile = updated);
  }

  Future<void> _toggleSync(bool enabled) async {
    final updated = _profile.copyWith(syncEnabled: enabled);
    await DatabaseHelper.instance.updateProfile(updated);
    setState(() => _profile = updated);
    final msg = enabled ? 'Synced with academic calendar' : 'Sync disabled';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 16),

          // Full Name field with a save button
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              suffixIcon: IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveName,
                tooltip: 'Save name',
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _saveName(),
          ),

          const SizedBox(height: 24),

          // Notifications toggle
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _profile.notificationsEnabled,
            onChanged: _toggleNotifications,
          ),

          // Sync toggle
          SwitchListTile(
            title: const Text('Sync with Academic Calendar'),
            subtitle: const Text('Canvas, Blackboard, etc.'),
            value: _profile.syncEnabled,
            onChanged: _toggleSync,
          ),
        ],
      ),
    );
  }
}

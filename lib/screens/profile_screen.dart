import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/profile_model.dart';

// Neo-cyberpunk palette
const kBgColor     = Color(0xFF0B0C10);
const kCardColor   = Color(0xFF1F2833);
const kAccentColor = Color(0xFF66FCF1);

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name saved')),
    );
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
    final msg =
    enabled ? 'Synced with academic calendar' : 'Sync disabled';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: kBgColor,
        body: Center(child: CircularProgressIndicator(color: kAccentColor)),
      );
    }

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: kCardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar & Name Card
          Card(
            color: kCardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: kAccentColor.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: kAccentColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: kBgColor,
                      prefixIcon:
                      const Icon(Icons.edit, color: kAccentColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save, color: kAccentColor),
                        onPressed: _saveName,
                        tooltip: 'Save name',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveName(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Settings Card
          Card(
            color: kCardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: kAccentColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[800],
                  secondary:
                  const Icon(Icons.notifications, color: Colors.white),
                  title: const Text('Enable Notifications',
                      style: TextStyle(color: Colors.white)),
                  value: _profile.notificationsEnabled,
                  onChanged: _toggleNotifications,
                ),
                const Divider(color: Colors.white24, height: 1),
                SwitchListTile(
                  activeColor: kAccentColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[800],
                  secondary: const Icon(Icons.sync, color: Colors.white),
                  title: const Text('Sync with Academic Calendar',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Canvas, Blackboard, etc.',
                      style: TextStyle(color: Colors.white70)),
                  value: _profile.syncEnabled,
                  onChanged: _toggleSync,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

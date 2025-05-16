import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/firebase_service.dart';

const kBgColor     = Color(0xFF0A1F44);
const kCardColor   = Color(0xFF1E2A56);
const kAccentColor = Color(0xFF4A90E2);

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey      = GlobalKey<FormState>();
  String _title       = '';
  String _description = '';
  DateTime _dateTime  = DateTime.now();

  late final AnimationController _controller;
  late final Animation<Offset>     _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: kAccentColor),
        ),
        child: child!,
      ),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null) return;

    setState(() {
      _dateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newGroup = EventModel(
      firebaseKey: '',
      title: _title,
      description: _description,
      dateTime: _dateTime,
      category: 'study_group',
      isRSVP: false,
      isCanceled: false,
    );
    await FirebaseService.instance.postGroup(newGroup);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('Create Study Group'),
        backgroundColor: kBgColor,
        elevation: 0,
      ),
      body: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Topic
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: kCardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Required' : null,
                  onSaved: (v) => _title = v!.trim(),
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: kCardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSaved: (v) => _description = v!.trim(),
                ),
                const SizedBox(height: 16),

                // Date/time picker
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'When: ${_dateTime.toLocal().toString().substring(0, 16)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDateTime,
                      style: TextButton.styleFrom(foregroundColor: kAccentColor),
                      child: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Create button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.group_add, color: Colors.white),
                  label: const Text('Create', style: TextStyle(color: Colors.white)),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

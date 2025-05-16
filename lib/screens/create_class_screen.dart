import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../services/firebase_service.dart';

const kBackgroundColor = Color(0xFF0A1931);
const kCardColor       = Color(0xFF0F3057);
const kAccentColor     = Color(0xFF1B4965);

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({Key? key}) : super(key: key);

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _nameCtrl      = TextEditingController();
  final _roomCtrl      = TextEditingController();
  final _profCtrl      = TextEditingController();
  final _materialsCtrl = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roomCtrl.dispose();
    _profCtrl.dispose();
    _materialsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cls = ClassModel(
      firebaseKey: '',
      key: '',
      courseName: _nameCtrl.text.trim(),
      roomNumber: _roomCtrl.text.trim(),
      professor: _profCtrl.text.trim(),
      materials: _materialsCtrl.text.trim(),
      dateTime: _selectedDateTime,
    );

    await FirebaseService.instance.postClass(cls);
    if (!mounted) return;
    Navigator.pop(context, cls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Class'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(controller: _nameCtrl, label: 'Course Name', validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              _buildField(controller: _roomCtrl, label: 'Room Number'),
              const SizedBox(height: 12),
              _buildField(controller: _profCtrl, label: 'Professor'),
              const SizedBox(height: 12),
              _buildField(controller: _materialsCtrl, label: 'Materials / Link'),
              const SizedBox(height: 24),

              // Date/Time picker
              Card(
                color: kCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.calendar_today, color: kAccentColor),
                  title: Text(
                    'Meeting: ${_selectedDateTime.toLocal().toString().substring(0,16)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: _pickDateTime,
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Save Class'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: kCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}

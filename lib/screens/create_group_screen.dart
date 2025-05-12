// lib/screens/create_group_screen.dart

import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/firebase_service.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Study Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Topic'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _title = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val!.trim(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  // 🚀 Post into Firebase Realtime Database
                  await FirebaseService.instance.postGroup(
                    EventModel(
                      title: _title,
                      description: _description,
                      dateTime: _dateTime,
                      category: 'study_group',
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

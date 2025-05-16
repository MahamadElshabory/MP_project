import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/class_model.dart';
import 'create_class_screen.dart';
import 'class_detail_screen.dart';

const kBackgroundColor = Color(0xFF0A1931);
const kCardColor       = Color(0xFF0F3057);
const kAccentColor     = Color(0xFF1B4965);

class ClassScheduleScreen extends StatefulWidget {
  final bool isTeacher;
  const ClassScheduleScreen({Key? key, required this.isTeacher})
      : super(key: key);

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Class Schedule'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<ClassModel>>(
        stream: fb.classesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent)),
            );
          }

          final classes = snapshot.data ?? [];
          if (classes.isEmpty) {
            return const Center(
              child: Text('No classes yet.',
                  style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: classes.length,
            itemBuilder: (context, i) {
              final c = classes[i];
              return Card(
                color: kCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.class_, color: kAccentColor),
                  title: Text(c.courseName,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'Room ${c.roomNumber} • Prof. ${c.professor}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.white54),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ClassDetailScreen(classModel: c),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.isTeacher
          ? FloatingActionButton(
        backgroundColor: kAccentColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final created = await Navigator.push<ClassModel>(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateClassScreen(),
            ),
          );
          if (created != null) setState(() {});
        },
      )
          : null,
    );
  }
}

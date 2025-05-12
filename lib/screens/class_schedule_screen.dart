import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/class_model.dart';
import '../widgets/class_card.dart';
import 'create_class_screen.dart';
import 'class_detail_screen.dart';

class ClassScheduleScreen extends StatelessWidget {
  final bool isTeacher;
  const ClassScheduleScreen({Key? key, required this.isTeacher})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Class Schedule')),
      body: StreamBuilder<List<ClassModel>>(
        stream: fb.classesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final classes = snapshot.data ?? [];
          if (classes.isEmpty) {
            return const Center(child: Text('No classes yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, i) {
              final c = classes[i];
              return ClassCard(
                title: c.courseName,
                subtitle: 'Room ${c.roomNumber} • Prof. ${c.professor}',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ClassDetailScreen(classModel: c),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CreateClassScreen(),
          ),
        ),
      )
          : null,
    );
  }
}

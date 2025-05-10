import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/class_model.dart';
import '../widgets/class_card.dart';
import 'class_detail_screen.dart';

class ClassScheduleScreen extends StatefulWidget {
  const ClassScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  late Future<List<ClassModel>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _classesFuture = DatabaseHelper.instance.getAllClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Schedule')),
      body: FutureBuilder<List<ClassModel>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final classes = snapshot.data ?? [];
          if (classes.isEmpty) {
            return const Center(child: Text('No classes found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final c = classes[index];
              return ClassCard(
                title: c.courseName,
                subtitle: '${c.day} ${c.startTime} - ${c.endTime}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClassDetailScreen(classModel: c),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

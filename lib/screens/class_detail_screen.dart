import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({Key? key, required this.classModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = classModel;
    return Scaffold(
      appBar: AppBar(title: Text(c.courseName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room: ${c.roomNumber}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Professor: ${c.professor}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Materials: ${c.materials}', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

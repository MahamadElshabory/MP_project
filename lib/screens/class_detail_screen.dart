import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({
    Key? key,
    required this.classModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classModel.courseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room: ${classModel.room}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Professor: ${classModel.professor}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Day: ${classModel.day}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Time: ${classModel.startTime} - ${classModel.endTime}',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

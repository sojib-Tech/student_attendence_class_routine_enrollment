import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentAttendanceTile extends StatelessWidget {
  final Student student;
  final String value;
  final ValueChanged<String> onChanged;

  const StudentAttendanceTile({
    super.key,
    required this.student,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.studentId),
        trailing: DropdownButton<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: 'Present', child: Text('Present')),
            DropdownMenuItem(value: 'Absent', child: Text('Absent')),
          ],
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';
import '../widgets/student_attendance_tile.dart';

class AttendanceMarkingScreen extends StatelessWidget {
  const AttendanceMarkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.courseId.isEmpty) {
          return const Center(child: Text('Enter a course ID to start.'));
        }

        if (provider.students.isEmpty) {
          return const Center(
            child: Text('No students found for this course.'),
          );
        }

        return Column(
          children: [
            ListTile(
              title: const Text('Attendance Date'),
              subtitle: Text(DateFormat.yMMMMd().format(provider.selectedDate)),
              trailing: TextButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: provider.selectedDate,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (selected != null && context.mounted) {
                    context.read<AttendanceProvider>().setDate(selected);
                  }
                },
                child: const Text('Pick Date'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  final student = provider.students[index];
                  return StudentAttendanceTile(
                    student: student,
                    value: provider.statusOf(student.studentId),
                    onChanged: (value) {
                      context
                          .read<AttendanceProvider>()
                          .setStatus(student.studentId, value);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: provider.isSaving
                      ? null
                      : () async {
                          final ok = await context
                              .read<AttendanceProvider>()
                              .saveAttendance();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok
                                    ? 'Attendance saved.'
                                    : 'Failed to save attendance.',
                              ),
                            ),
                          );
                        },
                  child: Text(
                    provider.isSaving ? 'Saving...' : 'Save Attendance',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.courseId.isEmpty) {
          return const Center(child: Text('Enter a course ID to see history.'));
        }

        if (provider.history.isEmpty) {
          return const Center(child: Text('No attendance history yet.'));
        }

        return ListView.builder(
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            final item = provider.history[index];
            final presentCount =
                item.records.values.where((v) => v == 'Present').length;
            final totalCount = item.records.length;

            return Card(
              child: ListTile(
                title: Text(DateFormat.yMMMMd().format(item.date)),
                subtitle: Text('Present: $presentCount / $totalCount'),
              ),
            );
          },
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';

class AttendanceSummaryScreen extends StatelessWidget {
  const AttendanceSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.courseId.isEmpty) {
          return const Center(child: Text('Enter a course ID to see summary.'));
        }

        final summaries = provider.studentSummaries;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: ListTile(
                title: const Text('Overall Attendance'),
                subtitle: Text(
                  'Present: ${provider.totalPresent} / ${provider.totalRecords}',
                ),
                trailing: Text(
                  '${provider.overallPercentage.toStringAsFixed(1)}%',
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (summaries.isEmpty)
              const Card(
                child: ListTile(
                  title: Text('No summary data available yet.'),
                ),
              )
            else
              ...summaries.map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'Present: ${item.presentCount} / ${item.totalCount}',
                    ),
                    trailing: Text(
                      '${item.percentage.toStringAsFixed(1)}%',
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


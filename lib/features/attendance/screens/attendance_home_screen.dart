import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';
import 'attendance_history_screen.dart';
import 'attendance_marking_screen.dart';
import 'attendance_summary_screen.dart';

class AttendanceHomeScreen extends StatefulWidget {
  const AttendanceHomeScreen({super.key});

  @override
  State<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  final TextEditingController _courseController = TextEditingController();
  int _index = 0;

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      AttendanceMarkingScreen(),
      AttendanceHistoryScreen(),
      AttendanceSummaryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Attendance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    context
                        .read<AttendanceProvider>()
                        .setCourse(_courseController.text);
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text('Load'),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(index: _index, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() => _index = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}


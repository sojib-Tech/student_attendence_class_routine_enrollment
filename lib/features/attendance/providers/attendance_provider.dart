import 'dart:async';

import 'package:flutter/material.dart';

import '../models/attendance_session.dart';
import '../models/student.dart';
import '../models/student_summary.dart';
import '../repositories/attendance_repository.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository repository;

  AttendanceProvider({required this.repository});

  String _courseId = '';
  DateTime _selectedDate = DateTime.now();
  List<Student> _students = [];
  List<AttendanceSession> _history = [];
  final Map<String, String> _draftRecords = {};
  bool _isSaving = false;
  String? _error;

  StreamSubscription<List<Student>>? _studentsSub;
  StreamSubscription<List<AttendanceSession>>? _historySub;

  String get courseId => _courseId;
  DateTime get selectedDate => _selectedDate;
  List<Student> get students => _students;
  List<AttendanceSession> get history => _history;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void setCourse(String value) {
    final normalized = value.trim();
    if (normalized == _courseId) return;
    _courseId = normalized;
    _students = [];
    _history = [];
    _draftRecords.clear();
    _error = null;
    _studentsSub?.cancel();
    _historySub?.cancel();

    if (_courseId.isEmpty) {
      notifyListeners();
      return;
    }

    _studentsSub = repository.watchStudents(_courseId).listen(
      (items) {
        _students = items;
        for (final student in _students) {
          _draftRecords.putIfAbsent(student.studentId, () => 'Absent');
        }
        notifyListeners();
      },
      onError: (Object e) {
        _error = e.toString();
        notifyListeners();
      },
    );

    _historySub = repository.watchAttendanceHistory(_courseId).listen(
      (items) {
        _history = items;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e.toString();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  String statusOf(String studentId) {
    return _draftRecords[studentId] ?? 'Absent';
  }

  void setStatus(String studentId, String status) {
    _draftRecords[studentId] = status;
    notifyListeners();
  }

  Future<bool> saveAttendance() async {
    if (_courseId.isEmpty || _students.isEmpty) return false;
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final records = <String, String>{
        for (final student in _students)
          student.studentId: _draftRecords[student.studentId] ?? 'Absent',
      };
      await repository.saveAttendance(
        courseId: _courseId,
        date: _selectedDate,
        records: records,
      );
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  int get totalPresent {
    return _history.fold<int>(
      0,
      (sum, session) =>
          sum + session.records.values.where((e) => e == 'Present').length,
    );
  }

  int get totalRecords {
    return _history.fold<int>(
      0,
      (sum, session) => sum + session.records.length,
    );
  }

  double get overallPercentage {
    if (totalRecords == 0) return 0;
    return (totalPresent / totalRecords) * 100;
  }

  List<StudentSummary> get studentSummaries {
    final nameById = <String, String>{
      for (final s in _students) s.studentId: s.name,
    };
    final presentMap = <String, int>{};
    final totalMap = <String, int>{};

    for (final session in _history) {
      session.records.forEach((studentKey, status) {
        totalMap[studentKey] = (totalMap[studentKey] ?? 0) + 1;
        if (status == 'Present') {
          presentMap[studentKey] = (presentMap[studentKey] ?? 0) + 1;
        }
      });
    }

    return totalMap.keys.map((studentKey) {
      return StudentSummary(
        studentKey: studentKey,
        name: nameById[studentKey] ?? studentKey,
        presentCount: presentMap[studentKey] ?? 0,
        totalCount: totalMap[studentKey] ?? 0,
      );
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  void dispose() {
    _studentsSub?.cancel();
    _historySub?.cancel();
    super.dispose();
  }
}


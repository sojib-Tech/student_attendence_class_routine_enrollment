import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attendance_session.dart';
import '../models/student.dart';

class AttendanceRepository {
  final FirebaseFirestore firestore;

  AttendanceRepository({required this.firestore});

  Stream<List<Student>> watchStudents(String courseId) {
    return firestore
        .collection('courses')
        .doc(courseId)
        .collection('students')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Student.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<AttendanceSession>> watchAttendanceHistory(String courseId) {
    return firestore
        .collection('courses')
        .doc(courseId)
        .collection('attendance')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final rawRecords = (data['records'] as Map<String, dynamic>? ?? {});
            return AttendanceSession(
              id: doc.id,
              date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
              records: rawRecords.map(
                (key, value) => MapEntry(key, value.toString()),
              ),
            );
          }).toList(),
        );
  }

  Future<void> saveAttendance({
    required String courseId,
    required DateTime date,
    required Map<String, String> records,
  }) async {
    final id = date.toIso8601String();
    await firestore
        .collection('courses')
        .doc(courseId)
        .collection('attendance')
        .doc(id)
        .set({
      'date': Timestamp.fromDate(date),
      'records': records,
    });
  }
}


class AttendanceSession {
  final String id;
  final DateTime date;
  final Map<String, String> records;

  const AttendanceSession({
    required this.id,
    required this.date,
    required this.records,
  });
}


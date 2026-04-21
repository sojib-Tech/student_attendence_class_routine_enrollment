class StudentSummary {
  final String studentKey;
  final String name;
  final int presentCount;
  final int totalCount;

  const StudentSummary({
    required this.studentKey,
    required this.name,
    required this.presentCount,
    required this.totalCount,
  });

  double get percentage =>
      totalCount == 0 ? 0 : (presentCount / totalCount) * 100;
}


class Student {
  final String id;
  final String name;
  final String studentId;

  const Student({
    required this.id,
    required this.name,
    required this.studentId,
  });

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      name: (map['name'] ?? '').toString(),
      studentId: (map['studentId'] ?? '').toString(),
    );
  }
}


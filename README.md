# Student Attendance + Summary Module

This project contains the Attendance and Attendance Summary part of the full system.

Implemented:
- Mark student attendance as Present or Absent
- Save attendance by date per course
- View attendance history
- View summary with total attended classes and attendance percentage

Firestore paths used:
- `courses/{courseId}/students/{studentId}`
- `courses/{courseId}/attendance/{attendanceId}`

Placeholders only:
- `lib/features/course_management/`
- `lib/features/student_enrollment/`
- `lib/features/routine/`

## Run

```powershell
flutter pub get
flutter run
```

## Test

```powershell
flutter test
```

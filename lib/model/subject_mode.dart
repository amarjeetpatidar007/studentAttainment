import 'package:objectbox/objectbox.dart';

import 'exam_model.dart';

@Entity()
class Subject {
  int id;

  @Unique()
  String subjectID;  // Unique identifier for the subject

  String subjectName;  // Subject name (e.g., Mathematics)

  // Relations
  final exams = ToMany<Exam>();  // One-to-many relation to Exam

  Subject({this.id = 0, required this.subjectID, required this.subjectName});
}

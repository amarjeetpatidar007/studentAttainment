import 'package:objectbox/objectbox.dart';
import 'package:stud_attain_minor_pro/model/student_model.dart';
import 'package:stud_attain_minor_pro/model/subject_mode.dart';

@Entity()
class ClassModel {
  int id;

  @Unique()
  String classID;  // Unique identifier for the class

  String className;  // Class name (e.g., Class 10)

  // Relations
  final subjects = ToMany<Subject>();  // One-to-many relation to Subject
  final students = ToMany<Student>();  // One-to-many relation to Student

  ClassModel({this.id = 0, required this.classID, required this.className});
}

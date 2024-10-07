import 'package:objectbox/objectbox.dart';
import 'package:stud_attain_minor_pro/model/result_model.dart';

@Entity()
class Student {
  int id;

  @Unique()
  String studentID;  // Unique identifier for the student

  String enrollmentNo;  // Student enrollment number
  String studentName;  // Student name

  // Relations
  final results = ToMany<Result>();  // One-to-many relation to Result

  Student({this.id = 0, required this.studentID, required this.enrollmentNo, required this.studentName});
}

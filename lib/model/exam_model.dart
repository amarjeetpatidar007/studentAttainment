
import 'package:objectbox/objectbox.dart';
import 'package:stud_attain_minor_pro/model/result_model.dart';

@Entity()
class Exam {
  int id;

  @Unique()
  String examID;  // Unique identifier for the exam

  String examName;  // Exam name (e.g., Midterm Exam)

  // Relations
  final results = ToMany<Result>();  // One-to-many relation to Result

  @Property()
  int subjectId;  // Reference to Subject (foreign key)

  Exam({this.id = 0, required this.examID,required this.subjectId,required this.examName});
}

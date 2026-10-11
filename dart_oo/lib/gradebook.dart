import 'student.dart';

/// 成绩册：用类建模"课程成绩册"。
/// 内部持有 List<Student>，构造时接收列表。
class GradeBook {
  final List<Student> _students;

  /// 构造时接收学生列表，复制一份避免外部修改内部状态。
  GradeBook(List<Student> students) : _students = List.of(students);
}

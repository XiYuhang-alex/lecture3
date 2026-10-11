import 'logger.dart';
import 'student.dart';

/// 成绩册：用类建模"课程成绩册"。
/// 内部持有 List<Student>，构造时接收列表。
/// 所有统计均用 Iterable 高阶方法链实现，不手写 for 循环。
/// 混入 Logger 后即可直接使用 log 方法输出日志。
class GradeBook with Logger {
  final List<Student> _students;

  /// 构造时接收学生列表，复制一份避免外部修改内部状态。
  GradeBook(List<Student> students) : _students = List.of(students);

  /// 平均分：fold 聚合求和后除以人数。
  double get average => _students.isEmpty
      ? 0
      : _students.fold<double>(0, (sum, s) => sum + s.score) /
          _students.length;

  /// 最高分学生：reduce 两两比较，通用化取值函数 selector。
  Student maxBy(double Function(Student) selector) =>
      _students.reduce((a, b) => selector(b) > selector(a) ? b : a);

  /// 及格人数：where 筛选后取长度。
  int get countPassed => _students.where((s) => s.passed).length;

  /// 按"优/良/中/不及格"分档，返回 Map<String, List<Student>>。
  /// 用 fold 聚合建组，??= 简化"取不到就新建"。
  Map<String, List<Student>> groupByGrade() => _students.fold(
        <String, List<Student>>{},
        (acc, s) {
          final key = s.score >= 90
              ? '优'
              : s.score >= 80
                  ? '良'
                  : s.score >= 60
                      ? '中'
                      : '不及格';
          (acc[key] ??= []).add(s);
          return acc;
        },
      );

  /// 统计摘要：经由混入的 Logger 输出。
  void printSummary() {
    log('共 ${_students.length} 人，平均分 ${average.toStringAsFixed(2)}，'
        '及格 $countPassed 人，最高分 ${maxBy((s) => s.score).name}');
  }
}

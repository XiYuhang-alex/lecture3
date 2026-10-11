import 'package:dart_oo/dart_oo.dart';

/// 课堂案例主程序：演示成绩册统计功能。
void main() {
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张伟', 78),
    Student('04', '刘洋', 85),
    // 命名构造：从 Map/JSON 造对象
    Student.fromJson({'id': '05', 'name': '陈静', 'score': 63}),
  ];

  final book = GradeBook(students);

  print('== 成绩册统计 ==');
  print('名单: $students');
  print('平均分: ${book.average.toStringAsFixed(2)}');
  print('最高分: ${book.maxBy((s) => s.score)}');
  print('及格人数: ${book.countPassed}');
  print('优良中分档: ');
  book.groupByGrade().forEach((grade, list) {
    print('  $grade (${list.length}人): ${list.map((s) => s.name).toList()}');
  });

  print('== 链式处理演示 ==');
  // map 映射：提取所有姓名
  print('姓名列表: ${students.map((s) => s.name).toList()}');
  // 复制后排序：不动原列表
  final sorted = [...students]..sort((a, b) => b.score.compareTo(a.score));
  print('按分数降序: ${sorted.map((s) => '${s.name}:${s.score.toStringAsFixed(0)}').toList()}');
  // firstWhere 查找（带 orElse 兜底）
  final top = students
      .firstWhere((s) => s.score >= 90, orElse: () => Student('-', '无'));
  print('90分以上: ${top.name}');
  // any / every 判定
  print('全部及格? ${students.every((s) => s.passed)}');
  print('有不及格? ${students.any((s) => !s.passed)}');
}

import 'package:dart_oo/dart_oo.dart';
import 'package:test/test.dart';

void main() {
  group('GradeBook 统计（正常路径）', () {
    late GradeBook book;
    setUp(() {
      book = GradeBook([
        Student('01', '李华', 92),
        Student('02', '王芳', 55),
        Student('03', '张伟', 78),
      ]);
    });

    test('平均分统计正确', () {
      // (92 + 55 + 78) / 3 = 75
      expect(book.average, closeTo(75, 0.001));
    });

    test('及格人数与最高分学生正确', () {
      expect(book.countPassed, 2);
      expect(book.maxBy((s) => s.score).name, '李华');
    });

    test('groupByGrade 按优良中分档正确', () {
      final groups = book.groupByGrade();
      expect(groups['优']!.length, 1);
      expect(groups['中']!.first.name, '张伟');
      expect(groups['不及格']!.first.name, '王芳');
    });

    test('fromJson 命名构造解析正确', () {
      final s = Student.fromJson({'id': '10', 'name': '陈静', 'score': 88});
      expect(s.name, '陈静');
      expect(s.score, 88);
      expect(s.passed, isTrue);
    });
  });

  group('Student 校验（异常路径）', () {
    test('分数越界抛 ArgumentError', () {
      final s = Student('04', '赵敏');
      expect(() => s.score = 120, throwsArgumentError);
      expect(() => s.score = -1, throwsArgumentError);
    });

    test('边界分数 0 与 100 合法', () {
      final s = Student('05', '孙磊');
      s.score = 0;
      expect(s.passed, isFalse);
      s.score = 100;
      expect(s.passed, isTrue);
    });

    test('空成绩册平均分为 0 不抛异常', () {
      expect(GradeBook([]).average, 0);
    });
  });
}

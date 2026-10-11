import 'package:dart_practice/dart_practice.dart';
import 'package:test/test.dart';

void main() {
  group('Shelf 统计（正常路径）', () {
    late Shelf shelf;
    setUp(() {
      shelf = Shelf([
        Book('a1', '书A', '文学', 2),
        Book('a2', '书B', '科幻', 0),
        Book('a3', '书C', '文学', 1),
      ]);
    });

    test('统计链输出正确', () {
      final s = shelf.stats();
      expect(s['总册目'], 3);
      expect(s['在馆总数'], 3);
      expect(s['平均在馆'], closeTo(1.0, 0.001));
      expect(s['最稀缺'], '书B');
      expect((s['类目(去重)'] as List).length, 2); // 文学/科幻 去重
      expect(s['还可借'], isTrue);
      expect(s['数据健康'], isTrue);
    });

    test('操作计数经由 Countable mixin 生效', () {
      final before = shelf.opCount;
      shelf.stats();
      shelf.stats();
      expect(shelf.opCount, before + 2);
    });

    test('borrow 成功扣减在馆量', () {
      shelf.borrow('a1');
      expect(shelf.stats()['在馆总数'], 2);
    });
  });

  group('Book 校验（异常路径）', () {
    test('在馆数量越界抛 ArgumentError', () {
      final b = Book('x1', '书X', '文学', 1);
      expect(() => b.onShelf = -1, throwsArgumentError);
      expect(() => b.onShelf = 4, throwsArgumentError); // maxCopies 默认 3
    });

    test('borrow 不存在的书抛 ArgumentError', () {
      final shelf = Shelf([Book('a1', '书A', '文学', 1)]);
      expect(() => shelf.borrow('nope'), throwsArgumentError);
    });

    test('把 0 本在馆的书再借出触发越界异常', () {
      final shelf = Shelf([Book('a1', '书A', '文学', 0)]);
      expect(() => shelf.borrow('a1'), throwsArgumentError);
    });
  });
}

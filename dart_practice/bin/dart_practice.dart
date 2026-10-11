import 'package:dart_practice/dart_practice.dart';

/// 自主实践演示：图书借阅统计（类设计 + mixin + 链式统计）。
void main() {
  final books = [
    Book('978-1', '算法导论', '计算机', 2),
    Book('978-2', '红楼梦', '文学', 0),
    Book('978-3', '三体', '科幻', 1),
    // 命名构造：从 Map/JSON 造对象
    Book.fromJson(
        {'isbn': '978-4', 'title': '活着', 'category': '文学', 'onShelf': 3}),
    Book.fromJson(
        {'isbn': '978-5', 'title': 'Flutter实战', 'category': '计算机', 'onShelf': 1}),
  ];

  final shelf = Shelf(books);

  print('== 图书借阅统计（自主实践） ==');
  shelf.stats().forEach((k, v) => print('$k: $v'));

  print('== 借出一本 978-3 三体 后 ==');
  shelf.borrow('978-3');
  shelf.stats().forEach((k, v) => print('$k: $v'));
}

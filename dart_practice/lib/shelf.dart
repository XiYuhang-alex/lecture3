import 'book.dart';
import 'countable.dart';

/// 书架：内部持有 List<Book>，构造时接收列表。
/// 用 mixin Countable 替代一层继承获得操作计数能力。
class Shelf with Countable {
  final List<Book> _books;

  Shelf(List<Book> books) : _books = List.of(books);

  /// 一组统计：组合 8 种链式方法
  /// fold / reduce / where / map / toSet / sort(复制后) / any / every。
  Map<String, Object> stats() {
    touch(); // 经由 mixin 计数

    final total = _books.length;
    // 1. fold：在馆总册数
    final onShelfTotal = _books.fold<int>(0, (s, b) => s + b.onShelf);
    // 2. fold 结果求平均
    final avgOnShelf = total == 0 ? 0.0 : onShelfTotal / total;
    // 3. reduce：在馆最少（最稀缺）的书
    final scarcest = total == 0
        ? '-'
        : _books.reduce((a, b) => b.onShelf < a.onShelf ? b : a).title;
    // 4. where + map + toList：全部借出的书名列表
    final borrowedOut =
        _books.where((b) => b.allBorrowed).map((b) => b.title).toList();
    // 5. map + toSet：类目去重
    final categories = _books.map((b) => b.category).toSet().toList();
    // 6. 复制后 sort：按在馆量降序，不动原列表
    final sorted = [..._books]..sort((a, b) => b.onShelf.compareTo(a.onShelf));
    // 7. any：还有书可借吗
    final anyBorrowable = _books.any((b) => b.onShelf > 0);
    // 8. every：数据是否健康（在馆量都不越界）
    final allHealthy = _books.every((b) => b.onShelf <= b.maxCopies);

    return {
      '总册目': total,
      '在馆总数': onShelfTotal,
      '平均在馆': avgOnShelf,
      '最稀缺': scarcest,
      '全部借出': borrowedOut,
      '类目(去重)': categories,
      '在馆降序': sorted.map((b) => '${b.title}:${b.onShelf}').toList(),
      '还可借': anyBorrowable,
      '数据健康': allHealthy,
      '操作次数(经mixin)': opCount,
    };
  }

  /// 借出一本：firstWhere 查找（orElse 兜底抛错），经校验 setter 扣减。
  void borrow(String isbn) {
    final b = _books.firstWhere(
      (b) => b.isbn == isbn,
      orElse: () => throw ArgumentError('无此书: $isbn'),
    );
    b.onShelf = b.onShelf - 1; // 在馆为 0 时 setter 抛越界异常
    touch();
  }
}

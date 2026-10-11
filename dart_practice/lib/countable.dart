/// 计数能力 mixin —— mixin 改造后的最终版本。
///
/// 改造前（一层继承版本，已废弃）：
/// ```dart
/// class CountedShelf extends Shelf {
///   int _opCount = 0;
///   int get opCount => _opCount;
///   void touch() => _opCount++;
/// }
/// ```
///
/// 改造理由：
/// 1. "计数"是一种能力，不是身份。CountedShelf extends Shelf 的 is-a 关系牵强——
///    带计数器的书架本质上还是书架，只是多了一个可观测行为。
/// 2. 继承把复用面限制在 Shelf 一族；mixin 可以混入任何类
///    （如以后给 ReaderBook 读者册也加计数），复用面更宽。
/// 3. 避免继承层次膨胀：如果再有"带日志的书架""带缓存的书架"，
///    继承需要多层子类组合，mixin 只需 `with A, B` 线性列出。
mixin Countable {
  int _opCount = 0;

  int get opCount => _opCount;

  /// 每执行一次统计/借还操作计数加一。
  void touch() => _opCount++;
}

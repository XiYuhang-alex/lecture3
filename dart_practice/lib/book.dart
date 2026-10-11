/// 图书类：字段封装、命名构造、校验 setter。
///
/// AI 使用标注：本文件由 TraeCode 辅助生成，本人逐行核验，
/// 并通过 test/shelf_test.dart 的正常与异常用例验证行为。
class Book {
  final String isbn;
  final String title;
  final String category;

  /// 在馆数量：私有字段（下划线前缀），只能经带校验的 setter 修改。
  int _onShelf;

  /// 馆藏上限，作为校验 setter 的上界。
  final int maxCopies;

  Book(this.isbn, this.title, this.category, this._onShelf,
      {this.maxCopies = 3});

  /// 命名构造：从 Map/JSON 造对象；maxCopies 缺省 3。
  Book.fromJson(Map<String, dynamic> json)
      : isbn = json['isbn'] as String,
        title = json['title'] as String,
        category = json['category'] as String,
        _onShelf = (json['onShelf'] as num).toInt(),
        maxCopies = (json['maxCopies'] as num?)?.toInt() ?? 3;

  int get onShelf => _onShelf;

  /// 校验 setter：在馆数量必须在 0~maxCopies 之间，越界抛异常。
  set onShelf(int v) {
    if (v < 0 || v > maxCopies) {
      throw ArgumentError('在馆数量越界：$v 不在 0~$maxCopies');
    }
    _onShelf = v;
  }

  /// 派生属性：该书是否全部借出。
  bool get allBorrowed => _onShelf == 0;

  @override
  String toString() => 'Book($isbn, $title, $category, 在馆$_onShelf)';
}

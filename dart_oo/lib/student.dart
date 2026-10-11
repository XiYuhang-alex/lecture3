/// 学生类：演示字段封装、命名构造函数与带校验的 setter。
class Student {
  final String id;
  final String name;

  /// 私有字段：Dart 没有 public/private 关键字，
  /// 库内以下划线前缀表示私有，外部无法直接访问。
  double _score;

  /// 默认构造：可选位置参数 [_score]，缺省为 0。
  Student(this.id, this.name, [this._score = 0]);

  /// 命名构造函数：从 Map/JSON 造对象的标准入口。
  /// 冒号后的初始化列表在构造体执行前运行。
  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        _score = (json['score'] as num).toDouble();

  /// getter：对外只读访问私有字段。
  double get score => _score;

  /// setter：写入前做范围校验，越界抛异常。
  set score(double v) {
    if (v < 0 || v > 100) throw ArgumentError('分数越界');
    _score = v;
  }

  /// 派生属性：及格与否由分数推导。
  bool get passed => _score >= 60;

  @override
  String toString() => 'Student($id, $name, ${_score.toStringAsFixed(1)})';
}

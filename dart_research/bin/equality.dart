/// 实验三：重写 == 与 hashCode 后，List.contains 与 Set 去重行为的变化。
/// 同一 main 内用"未重写"与"重写后"两个类对比，一次运行看全两种行为。

/// 未重写 == 与 hashCode 的版本：相等性按"同一对象"判定。
class PlainPoint {
  final int x, y;
  PlainPoint(this.x, this.y);

  @override
  String toString() => 'PlainPoint($x,$y)';
}

/// 重写 == 与 hashCode 的版本：按字段值判定相等。
class HashPoint {
  final int x, y;
  HashPoint(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HashPoint && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'HashPoint($x,$y)';
}

void main() {
  print('== 实验三：== 与 hashCode 重写 ==');

  final p1 = PlainPoint(1, 2), p2 = PlainPoint(1, 2);
  print('未重写: p1 == p2 -> ${p1 == p2}');
  print('未重写: list.contains(PlainPoint(1,2)) -> ${[p1, p2].contains(PlainPoint(1, 2))}');
  print('未重写: Set 去重 -> {p1, p2}.length = ${ {p1, p2}.length }');

  final h1 = HashPoint(1, 2), h2 = HashPoint(1, 2);
  print('重写后: h1 == h2 -> ${h1 == h2}');
  print('重写后: list.contains(HashPoint(1,2)) -> ${[h1, h2].contains(HashPoint(1, 2))}');
  print('重写后: Set 去重 -> {h1, h2}.length = ${ {h1, h2}.length }');
  print('identical(h1, h2) = ${identical(h1, h2)}（仍非同一对象，但值相等）');
}

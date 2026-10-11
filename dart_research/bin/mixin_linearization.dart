/// 实验一：mixin 线性化 —— 两个含同名方法的 mixin，改变 with 顺序观察调用结果。
///
/// 探索过程：先猜（以为 with 前面的优先），再运行，再对照
/// dart.dev/language/mixins 中 linearization 的描述修正理解。
mixin M1 {
  String who() => 'M1';
  void log(String msg) => print('[M1] $msg');
}

mixin M2 {
  String who() => 'M2';
  void log(String msg) => print('[M2] $msg');
}

class A with M1, M2 {}

class B with M2, M1 {}

void main() {
  print('== 实验一：mixin 线性化 ==');
  print('class A with M1, M2 -> who() 返回: ${A().who()}');
  A().log('hello');
  print('class B with M2, M1 -> who() 返回: ${B().who()}');
  B().log('hello');
  print('结论：后混入者覆盖同名方法（A 调 M2，B 调 M1）。');
}

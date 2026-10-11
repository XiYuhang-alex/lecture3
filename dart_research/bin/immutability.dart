/// 实验二：集合不可变 —— 对 const 列表 add，记录错误并总结使用时机。
void main() {
  print('== 实验二：集合不可变 ==');

  const constList = [1, 2, 3]; // 编译期常量
  final unmodList = List<int>.unmodifiable([1, 2, 3]); // 运行期只读视图
  final fixedList = List<int>.filled(3, 0, growable: false); // 固定长度

  print('const 列表: $constList');

  try {
    constList.add(4);
  } catch (e) {
    print('对 const 列表 add -> ${e.runtimeType}: ${(e as Error).toString().split(': ')[1]}');
  }

  try {
    unmodList.add(4);
  } catch (e) {
    print('对 List.unmodifiable add -> ${e.runtimeType}: ${(e as Error).toString().split(': ')[1]}');
  }

  try {
    fixedList.add(4);
  } catch (e) {
    print('对固定长度列表 add -> ${e.runtimeType}: ${(e as Error).toString().split(': ')[1]}');
  }

  // 常量规范化：值相同的 const 列表是同一个对象
  const a = [1, 2, 3];
  print('identical(constList, a) = ${identical(constList, a)}（const 规范化，共享同一实例）');
  print('结论见 README.md 使用时机总结。');
}

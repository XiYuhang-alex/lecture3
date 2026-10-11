/// 日志能力 mixin：任何类都可混入，复用同一批能力而不构成继承关系。
mixin Logger {
  /// [runtimeType] 由宿主类提供，日志前缀自动带上宿主类型名。
  void log(String msg) => print('[$runtimeType] $msg');
}

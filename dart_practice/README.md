# dart_practice —— 自主实践（课堂作业三）

主题：图书借阅统计。用类建模"书架-图书"，以 mixin 提供操作计数能力，
用集合链式方法完成一组统计。

## 运行方式

```bash
dart run          # 运行演示程序（bin/dart_practice.dart）
dart test         # 运行单元测试（test/shelf_test.dart，6 个用例全通过）
```

## 与自主实践任务的对应

| 任务 | 实现 |
| --- | --- |
| 1. 类设计合理性 | `Book`：`isbn/title/category` 封装字段、`_onShelf` 私有、命名构造 `fromJson`、带校验的 `set onShelf`（越界抛 `ArgumentError`）、派生 getter `allBorrowed` |
| 2. mixin 改造 | 用 `mixin Countable` 替代改造前 `class CountedShelf extends Shelf` 的一层继承；理由见 `lib/countable.dart` 头注释 |
| 3. 集合统计链 | `Shelf.stats()` 组合 8 种链式方法：`fold / reduce / where / map / toSet / sort（复制后）/ any / every`，超过"至少 5 个"的要求 |
| 4. 单元测试 | `test/shelf_test.dart`：6 个用例，覆盖正常统计路径与三类异常路径（越界 setter、查无此书、0 册再借出） |
| 5. AI 使用标注 | 见下节 |

## mixin 改造对照

改造前（一层继承）：

```dart
class CountedShelf extends Shelf {
  int _opCount = 0;
  int get opCount => _opCount;
  void touch() => _opCount++;
}
```

改造后（混入）：

```dart
mixin Countable {
  int _opCount = 0;
  int get opCount => _opCount;
  void touch() => _opCount++;
}

class Shelf with Countable { ... }
```

理由：计数是"能力"而非"身份"，`CountedShelf extends Shelf` 的 is-a 关系牵强；
mixin 可混入任何类，复用面更宽；多重能力（计数/日志/缓存）用 `with A, B` 线性组合，
避免继承层次膨胀。

## AI 使用标注

- 代码由 TraeCode（AI 编程助手）辅助生成，本人逐行阅读核验；
- 通过 `dart run` 实际运行核对统计输出（总册目、平均在馆、去重类目等均人工核对）；
- 通过 `dart test` 6 个用例（含 3 个异常路径）验证校验逻辑；
- 未直接提交未经验证的 AI 输出。

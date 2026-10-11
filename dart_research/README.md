# dart_research —— 独立研究任务（选做，课堂作业三）

按作业要求以手工编程与官方文档（dart.dev/language/mixins、dart.dev/language/collections、
api.dart.dev 中 List/Set 文档）检索为主完成：代码手工编写，AI（TraeCode）仅用于
运行命令与记录输出，结论基于真实运行结果归纳。

## 运行方式

```bash
dart run bin/mixin_linearization.dart   # 实验一
dart run bin/immutability.dart          # 实验二
dart run bin/equality.dart              # 实验三
```

## 实验一：mixin 线性化

**探索过程**：先假设"with 前面的优先"，编写两个含同名 `log` 的 mixin，
交换 `with` 顺序运行验证，再对照 dart.dev/language/mixins 的线性化（linearization）说明。

**真实输出**：

```text
class A with M1, M2 -> who() 返回: M2
[M2] hello
class B with M2, M1 -> who() 返回: M1
[M1] hello
```

**结论**：`with` 列表按顺序做线性叠加（superclass chain 从 Object 起，
依次叠加各 mixin），排在前面的类离基类近，排在后面的最后应用；同名方法
后应用者覆盖先应用者。因此 `with M1, M2` 调到 `M2.log`，`with M2, M1` 调到 `M1.log`。

## 实验二：集合不可变

**探索过程**：分别对 `const` 列表、`List.unmodifiable` 视图、固定长度列表
调用 `add`，用 try/catch 捕获记录错误类型；再验证 const 规范化。

**真实输出**：

```text
对 const 列表 add -> UnsupportedError: Cannot add to an unmodifiable list
对 List.unmodifiable add -> UnsupportedError: Cannot add to an unmodifiable list
对固定长度列表 add -> UnsupportedError: Cannot add to a fixed-length list
identical(constList, a) = true（const 规范化，共享同一实例）
```

**结论**：三者都不可 `add`，但语义不同——`const` 是编译期常量（值相同的
const 列表共享同一实例，且要求元素也是编译期常量）；`List.unmodifiable` 是
运行期只读视图（底层列表变了它也看不到修改）；固定长度仅限制长度不限制元素替换。

**不可变的使用时机**：① 配置、查表等固定数据用 `const`，防误改还省内存；
② 对外暴露内部集合时用 `List.unmodifiable`（或先 `List.of` 复制再返回），防止调用方
突破封装改内部状态；③ 需要定长但可替换元素时用 `List.filled(growable: false)`。

## 实验三：== 与 hashCode 重写

**探索过程**：写 `PlainPoint`（不重写）与 `HashPoint`（重写 `==` 和 `hashCode`）
对比 `List.contains` 与 `Set` 去重，一次运行看全两种行为。

**真实输出**：

```text
未重写: p1 == p2 -> false
未重写: list.contains(PlainPoint(1,2)) -> false
未重写: Set 去重 -> {p1, p2}.length = 2
重写后: h1 == h2 -> true
重写后: list.contains(HashPoint(1,2)) -> true
重写后: Set 去重 -> {h1, h2}.length = 1
```

**结论**：默认相等性是"同一对象"（identity）。重写 `==` 后 `List.contains`
按值找到等值元素；`Set`（哈希表实现）先比 `hashCode` 再比 `==`，因此
`==` 与 `hashCode` 必须同时重写且保持一致（相等对象必有相同哈希），否则去重失效。

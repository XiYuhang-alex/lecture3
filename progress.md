# 进度报告3（第5周·Dart语言基础二：面向对象与集合）

## 一、任务理解

本次作业要完成三块内容：① **案例复现**——跟随实践指南把课堂案例 dart_oo 完整复现：先建模（Student 类与 GradeBook 类），再为 GradeBook 实现统计功能（average、maxBy、countPassed、groupByGrade，全部用集合链式方法、禁止手写 for 循环），最后把日志能力抽成 mixin Logger 混入 GradeBook 并编写单元测试，三个步骤分别 Git 提交。② **自主实践**——独立设计一个新场景完成同类练习，满足五项要求：类设计合理性（字段封装、命名构造、校验 setter）、用 mixin 替代一层继承并说明理由、至少 5 个链式方法组合的统计、至少 2 个用例的单元测试（正常+异常路径）、AI 使用标注。③ **独立研究任务（选做）**——完成 mixin 线性化实验、集合不可变实践、== 与 hashCode 重写实验。

**验收标准**：`dart run` 统计输出正确；`dart test` 全部通过；3 次以上规范 Git 提交并推送到独立仓库 lecture3；进度报告按十节模板填写并附运行证据截图。

## 二、环境与工具

- 操作系统：Windows 11（LAPTOP-1V8USU86）
- Dart SDK：3.13.2 (stable)
- 版本控制：Git 2.55.0.windows.5，远程仓库 git@github.com:XiYuhang-alex/lecture3.git（SSH 密钥认证）
- AI 工具：TraeCode（GLM-5.3-Flash）
- 运行目标：Windows 控制台（`dart run`）。本次为纯 Dart 命令行项目，不涉及 Web/模拟器/真机。

## 三、过程记录

1. 检查环境：`dart --version`（3.13.2）、`git config`（XiYuhang-alex）、`ssh -T git@github.com`（密钥认证通过）。
2. `dart create dart_oo` 创建案例项目，`dart pub get` 拉取依赖。
3. **步骤一（建模）**：新建 `lib/student.dart`（Student 类：私有字段 _score、命名构造 fromJson、getter、带校验的 setter、派生 getter passed）与 `lib/gradebook.dart`（内部 List<Student>，构造时接收列表）；提交 `feat: Student & GradeBook models`。
4. **步骤二（统计功能）**：为 GradeBook 实现 average（fold）、maxBy（reduce）、countPassed（where）、groupByGrade（fold 建组），全部链式实现；编写 `bin/dart_oo.dart` 演示（含 map、复制后 sort、firstWhere、any/every）；`dart run` 核对输出；提交 `feat: gradebook stats via collection chains`。
5. **步骤三（mixin 与测试）**：新建 `lib/logger.dart`（mixin Logger），GradeBook 改为 `with Logger` 并新增 printSummary 经由 log 输出；编写 `test/gradebook_test.dart`（7 个用例，覆盖正常统计与越界异常）；`dart test` 全绿；提交 `feat: Logger mixin & unit tests`。
6. **自主实践**：`dart create dart_practice`（图书借阅统计场景）：Book 类（封装/fromJson/校验 setter）、Shelf 类（内部 List<Book>）、mixin Countable 替代一层继承、Shelf.stats() 组合 8 种链式方法、6 个测试用例；运行与测试通过后提交。
7. **独立研究**：`dart create dart_research`，编写并运行三个实验（mixin 线性化、集合不可变、==与hashCode），记录真实输出，在 README 归纳结论；提交。
8. 全屏截图 7 张（dart run、dart test、实验输出、git log、环境版本）。
9. 按十节模板填写进度报告，仓库推送至 GitHub。

## 四、关键代码

### 段1：GradeBook 统计链（案例复现步骤二核心）——AI 辅助生成，本人逐行核验

```dart
/// 平均分：fold 聚合求和后除以人数
double get average => _students.isEmpty
    ? 0
    : _students.fold<double>(0, (sum, s) => sum + s.score) / _students.length;

/// 按"优/良/中/不及格"分档：fold 建组
Map<String, List<Student>> groupByGrade() => _students.fold(
      <String, List<Student>>{},
      (acc, s) {
        final key = s.score >= 90 ? '优' : s.score >= 80 ? '良'
                  : s.score >= 60 ? '中' : '不及格';
        (acc[key] ??= []).add(s);   // 取不到分组就新建空列表
        return acc;
      },
    );
```

逐行解释：`average` 先用 `isEmpty` 守卫空列表除零；`fold<double>(0, ...)` 以 0 为初始值把每个学生分数累加进 sum（泛型显式指定 double，避免 int 初始值导致类型错误）；`groupByGrade` 以空 Map 为种子，对每个学生按分数段算出档位 key；`acc[key] ??= []` 是"不存在则初始化"的惯用法，返回该列表后 add 挂入学生；fold 最终返回整张分组表。**验证方式**：`dart run` 输出"优(1人):李华 / 良(1人):刘洋 / 中(2人):张伟,陈静 / 不及格(1人):王芳"与手工核对一致；测试用例断言 groups['优']!.length==1 等通过。

### 段2：mixin 改造前后对照（自主实践任务2）

```dart
// 改造前：一层继承
class CountedShelf extends Shelf {
  int _opCount = 0;
  int get opCount => _opCount;
  void touch() => _opCount++;
}

// 改造后：mixin
mixin Countable {
  int _opCount = 0;
  int get opCount => _opCount;
  void touch() => _opCount++;
}
class Shelf with Countable { ... }
```

**改造理由**："计数"是一种能力而非身份，`CountedShelf extends Shelf` 的 is-a 关系牵强；mixin 可混入任何类（如以后的读者册 ReaderBook 也能复用），复用面更宽；若再有日志、缓存等能力，`with A, B` 线性组合即可，避免继承层次膨胀。**验证方式**：测试"操作计数经由 Countable mixin 生效"通过（调用两次 stats 后 opCount 增加 2）。

### 段3：Student 校验 setter 与命名构造（案例复现步骤一核心）

```dart
Student.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      _score = (json['score'] as num).toDouble();

set score(double v) {
  if (v < 0 || v > 100) throw ArgumentError('分数越界');
  _score = v;
}
```

逐行解释：命名构造 fromJson 用初始化列表（冒号后）在构造体执行前完成字段赋值；`json['score'] as num` 再 `.toDouble()` 兼容 int/double 两种 JSON 数字类型；setter 在写入前校验 0~100 区间，越界抛 ArgumentError，保证对象始终处于合法状态。**验证方式**：测试用例 `expect(() => s.score = 120, throwsArgumentError)` 通过；fromJson 用例断言各字段解析正确。

## 五、检查点结果

| 检查点 | 结果 | 证据 |
| --- | --- | --- |
| `dart run` 统计输出正确 | 通过：平均分 74.60、及格 4 人、最高分李华、优/良/中/不及格分档正确 | screenshots/01_dart_run_dart_oo.png |
| `dart test` 全部通过 | 通过：+7 All tests passed! | screenshots/02_dart_test_dart_oo.png |
| 能解释 with 顺序对同名方法的影响 | 通过：后混入者覆盖同名方法（实验一：with M1,M2 调 M2，with M2,M1 调 M1） | screenshots/05_dart_research_experiments.png |
| 自主实践运行与测试 | 通过：dart run 统计正确；+6 All tests passed! | screenshots/03、04 |

## 六、问题与调试

**问题1（类型相关）：dart test 出现 `Failing tests: loading test\dart_oo_test.dart`。**
定位过程：7 个自写用例全部通过，唯独模板自带的 `test/dart_oo_test.dart` 加载失败。打开该文件发现它 `import 'package:dart_oo/dart_oo.dart'` 后调用模板函数 `calculate()`，而我已把 `lib/dart_oo.dart` 从模板改为纯导出文件，`calculate` 符号不存在，编译期即报方法未定义，导致整个测试文件加载失败。
解决方案：删除模板遗留的 `test/dart_oo_test.dart`（及其对应的模板入口代码），保留自写的 `gradebook_test.dart`，重新 `dart test` 全绿。
教训：`dart create` 生成的模板测试与库代码是配套的，改掉库以后必须同步清理模板测试，否则 dart test 会因一个文件失败而整体报红。

**问题2（环境）：`dart pub get` 报 `PathAccessException: Creation of temporary directory failed ... .pub-cache\_temp (OS Error: 拒绝访问, errno = 5)`。**
定位：pub 缓存目录位于 `C:\Users\lenovo\flutter_dev\.pub-cache`，该路径被系统权限策略拦截写入临时目录。解决：在无此限制的终端环境运行 `dart pub get`，依赖正常拉取（+yaml 3.1.4 等 48 项）。

**问题3（工具）：新开 PowerShell 窗口执行 `git log` 报 `fatal: unable to execute pager 'more'`。**
定位：新窗口 PATH 不完整找不到分页器 more。解决：改用 `git --no-pager log --oneline -15` 禁用分页器，提交记录正常显示。

## 七、AI 使用记录（TraeCode 使用清单）

| # | 用途 | 指令摘要 | 输出 | 本人验证方式 |
| --- | --- | --- | --- | --- |
| 1 | 读取作业文档 | 读取 guide-3 / homework-3 / progress-report-3 三个 docx | 任务清单与验收标准 | 与原文档逐条核对 |
| 2 | 生成 dart_oo 代码 | 按指南三步骤生成 student/gradebook/logger/main/test | 5 个代码文件 | 逐行阅读核验；dart run 输出与手工计算核对（平均 74.60、及格 4 人等）；dart test 7 用例全绿 |
| 3 | 生成 dart_practice 代码 | 按自主实践五项要求生成 Book/Shelf/Countable/测试 | 5 个代码文件+README | 逐行阅读核验；运行输出人工核对（总册目 5、平均在馆 1.4、去重类目 3 项等）；dart test 6 用例全绿 |
| 4 | 生成 dart_research 实验 | 按选做任务生成三个实验程序 | 3 个实验文件+README | 实际运行记录真实输出；结论仅基于可复现的输出归纳 |
| 5 | 运行与截图 | 执行 dart run/test、git 命令、全屏截图脚本 | 终端输出、7 张截图 | 截图逐张人工检查内容与清晰度 |
| 6 | 撰写报告 | 按十节模板整理过程与证据 | progress.md 与 docx | 事实均来自上述真实运行记录 |

红线自查：未直接提交任何未经验证的 AI 生成代码；AI 使用记录真实可追溯；独立研究结论以真实运行输出为依据（AI 仅协助运行与记录，结论可由任何人重跑复现）。

## 八、证据截图

| 截图 | 说明 |
| --- | --- |
| 01_dart_run_dart_oo.png | dart_oo 执行 dart run：成绩册统计（mixin 日志）与链式处理演示输出全部正确（全屏） |
| 02_dart_test_dart_oo.png | dart_oo 执行 dart test：+7 All tests passed!，7 个用例全绿（全屏） |
| 03_dart_run_dart_practice.png | dart_practice 执行 dart run：图书借阅统计输出正确，操作计数经 mixin 生效（全屏） |
| 04_dart_test_dart_practice.png | dart_practice 执行 dart test：+6 All tests passed!（全屏） |
| 05_dart_research_experiments.png | 三个独立研究实验的真实输出：mixin 线性化、不可变列表报错、==重写前后对比（全屏） |
| 06_git_log.png | git remote 与 git log：仓库地址 XiYuhang-alex/lecture3 及 5 次规范提交（全屏） |
| 07_environment.png | 环境信息：Dart SDK 3.13.2、Git 2.55.0、Python 3.13.15（全屏） |

## 九、自评

**6.1 案例复现**
- dart_oo 完整复现（15/15）：三步骤全部完成，代码与指南一致（fromJson 命名构造、校验 setter、List 内部承载、四项统计全链式、Logger mixin 混入）。
- 检查点（5/5）：dart run 统计输出正确；dart test 7 用例全绿；能口头解释 with 顺序（后混入者胜，已用实验一验证）。
- Git 规范（5/5）：3 次按步骤的 feat 提交（ea49206 → 71fdf49 → 6eb93b7），推送到独立仓库 lecture3。
- 报告记录（5/5）：本报告十节完整，progress.md 同步入仓。

**6.2 自主实践基本要求**
1. 类设计合理性 ✓：Book 字段封装（isbn/title/category/_onShelf/maxCopies）、命名构造 fromJson、校验 setter（0~maxCopies 越界抛错）、派生 getter allBorrowed。
2. mixin 改造 ✓：mixin Countable 替代 CountedShelf extends Shelf 一层继承，理由见第四节段2（能力而非身份、复用面、避免层次膨胀）。
3. 集合统计链 ✓：Shelf.stats() 组合 8 种链式方法（fold/reduce/where/map/toSet/sort 复制后/any/every），超过"至少 5 个"。
4. 单元测试 ✓：6 个用例，覆盖正常统计路径与三类异常路径（越界 setter、查无此书、0 册再借出）。
5. AI 使用标注 ✓：代码文件头注释、dart_practice/README、本报告第七节三处标注。

**6.3 独立研究任务（选做）**
1. mixin 线性化实验 ✓：with M1,M2 → 调 M2；with M2,M1 → 调 M1；结论：线性化顺序决定同名方法归属，后混入者胜。
2. 集合不可变实践 ✓：const 列表与 List.unmodifiable add 均抛 UnsupportedError: Cannot add to an unmodifiable list；固定长度列表抛 Cannot add to a fixed-length list；const 规范化 identical==true；使用时机总结见 dart_research/README。
3. == 与 hashCode 重写 ✓：未重写时 contains=false、Set 去重后 length=2；重写后 contains=true、length=1；结论：== 与 hashCode 必须成对重写且保持一致，否则哈希容器去重失效。

## 十、一句话收获与下一步计划

**一句话收获**：mixin 解决的是"能力复用"而不是"身份分类"，集合链式方法让统计代码一行顶十行——但复制列表再 sort、== 与 hashCode 成对重写这些细节不踩一次坑记不住。

**遗留问题**：mixin 的 `on` 约束与混入链中 `super` 调用的完整解析顺序，本次只做了同名方法覆盖的最简实验，还需在更复杂场景下体会。

**下次课预习要点**：Flutter 开发环境与 Widget 基础——按课程要求提前装好 Flutter SDK 并跑通 `flutter doctor`，了解"Widget 是类、界面数据是集合"如何衔接本课知识。

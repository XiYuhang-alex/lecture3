# lecture3 —— MAPP 第3课（第5周）Dart语言基础二：面向对象与集合

本仓库为课堂作业三的独立项目仓库，包含案例复现、自主实践、独立研究（选做）三个子项目，
进度报告见 [progress.md](progress.md) 与 `mapp-progress-report-3.docx`。

## 目录结构

| 目录 | 内容 |
| --- | --- |
| `dart_oo/` | 案例复现：成绩册统计（Student / GradeBook / Logger mixin，3 次分步提交） |
| `dart_practice/` | 自主实践：图书借阅统计（Book / Shelf / Countable mixin，8 种链式统计） |
| `dart_research/` | 独立研究（选做）：mixin 线性化 / 集合不可变 / ==与 hashCode 三个实验 |
| `screenshots/` | 全屏截图：dart run、dart test、git log、环境信息 |
| `mapp-progress-report-3.docx` | 进度报告三（按十节模板填写，含截图） |
| `progress.md` | 进度报告三全文（供复制到雨课堂答题区） |

## 运行方式

```bash
cd dart_oo        && dart run && dart test
cd dart_practice  && dart run && dart test
cd dart_research  && dart run bin/mixin_linearization.dart && dart run bin/immutability.dart && dart run bin/equality.dart
```

## Git 提交流程（dart_oo 按指南三步）

1. `feat: Student & GradeBook models`
2. `feat: gradebook stats via collection chains`
3. `feat: Logger mixin & unit tests`

## AI 使用说明

代码由 TraeCode 辅助生成，全部经本人实际运行 `dart run` / `dart test` 验证，
AI 使用明细见进度报告第七节。

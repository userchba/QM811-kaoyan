# notes —— 量子力学复习讲义

本目录与根目录的 **811 考研真题集相互独立**，是整理者的量子力学复习讲义，
不属于真题集的一部分，也不参与 `811.tex` 的编译。

## 内容

| 文件 | 说明 |
| ---- | ---- |
| `AQM_ch1_foundations.tex` | 高等量子力学 第一章讲义的 LaTeX 版（独立文档，非真题集） |
| `AQM_ch1_foundations.pdf` | 上述讲义编译产物 |
| `reference/AQM-2024-09-03.md` | 讲义的 Markdown 原始稿，`AQM_ch1_foundations.tex` 由其整理而来 |
| `compile.sh` | 本目录讲义的编译脚本 |

## 编译

```bash
cd notes
./compile.sh AQM_ch1_foundations   # 参数为文件名（不含 .tex）
```

> 该脚本同样使用 `xelatex` 并编译两遍，与根目录的 `build.sh` 互不影响。

## 说明

- 讲义使用独立的 `\documentclass{article}`，**不加载根目录的 `style.cls`**，
  因此修改真题模板不会影响这里。
- 若只需真题集，可完全忽略本目录。

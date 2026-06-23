#!/bin/bash
# 编译 notes 目录下的 .tex 文件
# 用法: ./compile.sh [文件名(不含扩展名)]
# 例如: ./compile.sh AQM_ch1_foundations

set -e

cd "$(dirname "$0")"

# 默认编译 AQM_ch1_foundations.tex
TARGET="${1:-AQM_ch1_foundations}"

if [ ! -f "${TARGET}.tex" ]; then
    echo "错误：未找到 ${TARGET}.tex"
    exit 1
fi

echo "==> 第一次编译 ${TARGET}.tex (生成 aux/toc)..."
xelatex -interaction=nonstopmode "${TARGET}.tex" > /dev/null

echo "==> 第二次编译 ${TARGET}.tex (解析交叉引用)..."
xelatex -interaction=nonstopmode "${TARGET}.tex" 2>&1 | tail -3

# 检查错误
if grep -qE "^! " "${TARGET}.log"; then
    echo "==> 编译失败，存在错误："
    grep -E "^! " "${TARGET}.log"
    exit 1
fi

echo "==> 编译成功：${TARGET}.pdf"

#!/bin/bash
# 一键构建 811 量子力学真题集
#
# 生成两个产物：
#   811.pdf              含答案版（\answertrue）
#   811_noanswer.pdf     纯试题版（\answerfalse，便于先做题后对答案）
#
# 用法：
#   ./build.sh            构建两个版本
#   ./build.sh answers    只构建含答案版
#   ./build.sh noanswer   只构建纯试题版
#
# 注意：必须使用 xelatex，且需要编译两遍以正确生成目录与交叉引用。

set -e
cd "$(dirname "$0")"

TARGET="${1:-all}"

# check_build <jobname>
# 检查编译日志中是否存在 ! 级错误
check_build() {
    local job="$1"
    if grep -qE "^! " "${job}.log"; then
        echo "==> 编译失败：${job}.log 中存在错误"
        grep -E "^! " "${job}.log" | head -20
        exit 1
    fi
}

# build <jobname> <answertrue|answerfalse>
# 通过临时副本切换答案开关，不修改 811.tex 本身
build() {
    local job="$1" flag="$2"
    local src="${job}.tex"

    echo "==> 构建 ${job}.pdf （${flag}）"

    # 生成临时源文件；job 名为 811 时源文件即 811.tex 本身，无需复制
    if [ "$src" = "811.tex" ]; then
        if [ "$flag" = "answerfalse" ]; then
            sed 's/\\answertrue/\\answerfalse/' 811.tex > "${job}_tmp.tex"
            src="${job}_tmp.tex"
        fi
    else
        sed "s/\\\\answertrue/\\\\${flag}/" 811.tex > "$src"
    fi

    # 迭代编译直到 .toc 收敛。
    # 目录页码由 .toc 决定，而目录本身又可能改变分页，因此需要多遍编译；
    # 通常在第三遍后稳定（新增目录条目导致目录页数变化时尤其如此）。
    local pass=1 prev_toc=""
    while [ "$pass" -le 5 ]; do
        xelatex -interaction=nonstopmode -jobname="${job}" "$src" > /dev/null
        if [ -n "$prev_toc" ] && diff -q "$prev_toc" "${job}.toc" > /dev/null 2>&1; then
            echo "    （第 ${pass} 遍后目录收敛）"
            break
        fi
        cp "${job}.toc" "${job}.toc.prev" 2>/dev/null
        prev_toc="${job}.toc.prev"
        pass=$((pass + 1))
    done
    rm -f "${job}.toc.prev"

    check_build "${job}"

    # 清理临时源文件与中间产物（811.tex 本身必须保留）
    if [ "$src" != "811.tex" ]; then
        rm -f "$src"
    fi
    rm -f "${job}.aux" "${job}.log" "${job}.out" "${job}.toc"

    if [ -f "${job}.pdf" ]; then
        local pages
        pages=$(pdfinfo "${job}.pdf" 2>/dev/null | awk '/^Pages/{print $2}')
        echo "==> 完成：${job}.pdf （${pages:-?} 页）"
    else
        echo "==> 错误：未生成 ${job}.pdf"
        exit 1
    fi
}

case "$TARGET" in
    all)
        build 811         answertrue
        build 811_noanswer answerfalse
        ;;
    answers)
        build 811 answertrue
        ;;
    noanswer)
        build 811_noanswer answerfalse
        ;;
    *)
        echo "未知参数：$TARGET"
        echo "用法：$0 [all|answers|noanswer]"
        exit 1
        ;;
esac

echo "==> 全部完成"

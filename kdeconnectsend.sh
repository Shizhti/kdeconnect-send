#!/bin/bash

# 版本信息
VERSION="1.1"

show_help() {
    echo "文件传输脚本 v$VERSION"
    echo "用途：向指定设备发送指定目录的最新文件"
    echo
    echo "用法："
    echo "  $0 [选项]"
    echo
    echo "选项："
    echo "  -d, --device <ID>     指定目标设备ID（必须）"
    echo "  -p, --path <路径>      指定要监控的文件夹路径（必须）"
    echo "  -n, --newest          发送最新修改的文件（必须）"
    echo "  -ls, --list-devices   列出可用设备"
    echo "  -h, --help            显示本帮助信息"
    echo "  -v, --version         显示版本信息"
    echo
    echo "示例："
    echo "  $0 -d abc123 -p ~/Downloads -n"
    echo "  $0 --list-devices"
}

# 初始化变量
device=""
folder=""
newest=0

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--device)
            # 特殊处理 -d -ls 的误输入情况
            if [[ "$2" == "-ls" ]]; then
                echo "错误：设备ID不能是 '-ls'" >&2
                exit 1
            fi
            device="$2"
            shift 2
            ;;
        -p|--path)
            folder="$2"
            shift 2
            ;;
        -n|--newest)
            newest=1
            shift
            ;;
        -ls|--list-devices)
            kdeconnect-cli --list-available
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "v$VERSION"
            exit 0
            ;;
        *)
            echo "未知参数: $1" >&2
            exit 1
            ;;
    esac
done

# 参数检查 --------------------------------------------------------
if [[ -z "$device" || -z "$folder" ]]; then
    echo "必须指定设备ID（-d/--device）和文件夹路径（-p/--path）" >&2
    echo "使用 -h 查看帮助信息"
    exit 1
fi

if [[ $newest -ne 1 ]]; then
    echo "必须使用 -n/--newest 选项指定发送最新文件" >&2
    echo "使用 -h 查看帮助信息"
    exit 1
fi

# 文件夹检查 ------------------------------------------------------
if [[ ! -d "$folder" ]]; then
    echo "错误：路径 '$folder' 不存在或不是目录" >&2
    exit 1
fi

# 查找最新文件 ----------------------------------------------------
latest_file=""
latest_time=0

shopt -s dotglob
for file in "$folder"/*; do
    if [[ -f "$file" ]]; then
        mtime=$(stat -c %Y "$file")
        if (( mtime > latest_time )); then
            latest_time=$mtime
            latest_file="$file"
        fi
    fi
done
shopt -u dotglob

if [[ -z "$latest_file" ]]; then
    echo "错误：目录 '$folder' 中没有文件" >&2
    exit 1
fi

# 发送文件 --------------------------------------------------------
echo "正在发送文件：$latest_file"
if ! kdeconnect-cli -d "$device" --share "$latest_file"; then
    echo "文件发送失败，请检查："
    echo "1. 设备是否在线"
    echo "2. 设备ID是否正确（使用 -ls 查看可用设备）"
    echo "3. 是否已安装KDE Connect客户端"
    exit 1
fi

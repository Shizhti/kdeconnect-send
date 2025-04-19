# kdeconnect-send
快速发送最新文件给指定KDE Connect设备
依赖：`kdeconnect-cli`
# 使用前
Step 1: 下载脚本

Step 2: 给予执行权限
```bash
chmod +x kdeconnectsend.sh
```
# 如何使用

```bash
./kdeconnectsend.sh --help
文件传输脚本 v1.1
用途：向指定设备发送指定目录的最新文件

用法：
  ./kdesend.sh [选项]

选项：
  -d, --device <ID>     指定目标设备ID（必须）
  -p, --path <路径>      指定要监控的文件夹路径（必须）
  -n, --newest          发送最新修改的文件（必须）
  -ls, --list-devices   列出可用设备
  -h, --help            显示本帮助信息
  -v, --version         显示版本信息

示例：
  ./kdesend.sh -d abc123 -p ~/Downloads -n
  ./kdesend.sh --list-devices
```
可以直接绑定WM快捷键，这样可以一键发送文件到指定设备

#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "配置文件 $CONFIG_FILE 不存在"
    exit 1
fi

if ! ping -c 1 baidu.com &>/dev/null; then
    output_status "$PING_LOG_FILE" "Network is down."
    # 如果网络不通，则执行检查连接的脚本
    if pgrep -f "check_connection.sh" >/dev/null; then
        output_status "$PING_LOG_FILE" "check_connection.sh is already running."
    else
        $SCRIPT_DIR/check_connection.sh
    fi
else
    output_status "$PING_LOG_FILE" "Network is up."
fi
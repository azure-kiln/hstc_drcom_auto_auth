#!/bin/bash
# 检查连接状态
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "The config.sh is not found"
    exit 1
fi

# 执行 login.sh
# 判断进程中是否有脚本在执行
if pgrep -f "auto_login_and_verify.sh" >/dev/null; then
    output_status "$STATUS_LOG_FILE" "auto_login_and_verify.sh is already running."
else
    $SCRIPT_DIR/auto_login_and_verify.sh
fi

output_status "$STATUS_LOG_FILE" "shell check_connection.sh completed successfully"
#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "$SCRIPT_DIR"

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
    echo "The config.sh is not found echo by check_loop"
    source "$CONFIG_FILE"
else
    echo "The config.sh is not found"
    exit 1
fi

for i in {0..3}; do
    output_status "$PING_LOG_FILE" "check_network $i"
    $SCRIPT_DIR/check_network.sh
    sleep 15
done

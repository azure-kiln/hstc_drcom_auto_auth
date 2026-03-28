#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "The config.sh is not found"
    exit 1
fi

output_status "$STATUS_LOG_FILE" "Starting to check the connection status now."
output_status "$STATUS_LOG_FILE" "$VERIFY_URL"
# 响应内容
GET_RESPONSE=$(curl -b $COOKIE_FILE -H "User-Agent: $USER_AGENT" -s -w "%{http_code}" -D $HEADERS_FILE $VERIFY_URL | tee $CHECK_LOGIN_CONTENT)

if grep -q "uid" $CHECK_LOGIN_CONTENT; then
  output_status "$STATUS_LOG_FILE" "The connection info is available."
else
  output_status "$STATUS_LOG_FILE" "Drcom's UID is missing. Trying to login now."
  # 执行 login.sh
  # 判断进程中是否有在执行
  if pgrep -f "auto_login_and_verify.sh" >/dev/null; then
    output_status "$STATUS_LOG_FILE" "auto_login_and_verify.sh is already running."
  else
    $SCRIPT_DIR/auto_login_and_verify.sh
  fi
fi
output_status "$STATUS_LOG_FILE" "shell check_connection.sh completed successfully"